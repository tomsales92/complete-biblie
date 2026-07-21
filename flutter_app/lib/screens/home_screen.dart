import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/bible_data.dart';
import '../models/bible_book.dart';
import '../models/panorama.dart';
import '../models/read_entry.dart';
import '../models/reading_day_group.dart';
import '../services/auth_service.dart';
import '../services/bible_service.dart';
import '../widgets/chapter_grid.dart';
import '../widgets/history_section.dart';
import '../widgets/panorama_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.user,
    required this.authService,
    required this.bibleService,
  });

  final User user;
  final AuthService authService;
  final BibleService bibleService;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedBook = bibleBooks.first.name;
  List<ReadEntry> _reads = [];
  List<ReadEntry> _todayReads = [];
  List<ReadingDayGroup> _readingHistory = [];
  Panorama? _panorama;
  DateTime _targetDate = DateTime(DateTime.now().year, 12, 31);
  bool _loading = true;
  int? _togglingChapter;

  BibleBook get _selectedBookInfo =>
      findBook(_selectedBook) ?? bibleBooks.first;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _loading = true);
    try {
      final reads = await widget.bibleService.getReads(widget.user.uid);
      if (!mounted) return;
      setState(() {
        _reads = reads;
        _applyDerivedState();
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _applyDerivedState() {
    final today = todayDateString();
    _todayReads = _reads.where((read) => read.date == today).toList();
    _readingHistory = groupReadsByDate(_reads);
    _panorama = buildPanorama(_reads, formatDate(_targetDate));
  }

  bool _isChapterRead(int chapter) {
    return _reads.any(
      (read) => read.book == _selectedBook && read.chapter == chapter,
    );
  }

  Future<void> _toggleChapter(int chapter) async {
    if (_togglingChapter != null) return;

    setState(() => _togglingChapter = chapter);
    final isRead = _isChapterRead(chapter);

    try {
      if (isRead) {
        final entry = _reads.firstWhere(
          (read) => read.book == _selectedBook && read.chapter == chapter,
        );
        await widget.bibleService.unmarkRead(widget.user.uid, entry);
        if (!mounted) return;
        setState(() {
          _reads = _reads.where((read) => read.id != entry.id).toList();
          _applyDerivedState();
        });
      } else {
        final entry = await widget.bibleService.markAsRead(
          widget.user.uid,
          _selectedBook,
          chapter,
        );
        if (!mounted) return;
        setState(() {
          _reads = [..._reads, entry];
          _applyDerivedState();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    } finally {
      if (mounted) setState(() => _togglingChapter = null);
    }
  }

  void _onTargetDateChanged(DateTime date) {
    setState(() {
      _targetDate = date;
      _panorama = buildPanorama(_reads, formatDate(_targetDate));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leitura Bíblica'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout),
            onPressed: () => widget.authService.logout(),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAll,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  PanoramaCard(
                    panorama: _panorama,
                    targetDate: _targetDate,
                    onTargetDateChanged: _onTargetDateChanged,
                  ),
                  const SizedBox(height: 16),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.today, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            'Lidos hoje: ${_todayReads.length}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  HistorySection(
                    history: _readingHistory,
                    totalReads: _reads.length,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedBook,
                    decoration: const InputDecoration(
                      labelText: 'Livro',
                      border: OutlineInputBorder(),
                    ),
                    items: bibleBooks
                        .map(
                          (book) => DropdownMenuItem(
                            value: book.name,
                            child: Text(book.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _selectedBook = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  ChapterGrid(
                    chapterCount: _selectedBookInfo.chapters,
                    isChapterRead: _isChapterRead,
                    togglingChapter: _togglingChapter,
                    onToggle: _toggleChapter,
                  ),
                ],
              ),
            ),
    );
  }
}
