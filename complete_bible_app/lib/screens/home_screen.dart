import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/bible_data.dart';
import '../models/bible_book.dart';
import '../models/panorama.dart';
import '../models/read_entry.dart';
import '../models/reading_day_group.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/bible_service.dart';
import '../services/theme_controller.dart';
import '../services/user_profile_service.dart';
import '../widgets/chapter_grid.dart';
import '../widgets/history_section.dart';
import '../widgets/panorama_card.dart';
import '../widgets/theme_toggle_button.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.user,
    required this.authService,
    required this.bibleService,
    required this.userProfileService,
    required this.themeController,
  });

  final User user;
  final AuthService authService;
  final BibleService bibleService;
  final UserProfileService userProfileService;
  final ThemeController themeController;

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
  String? _profileName;

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
      final results = await Future.wait([
        widget.bibleService.getReads(widget.user.uid),
        widget.userProfileService.getProfile(widget.user.uid),
      ]);
      if (!mounted) return;
      final reads = results[0] as List<ReadEntry>;
      final profile = results[1] as UserProfile?;
      setState(() {
        _reads = reads;
        _profileName = profile?.name;
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

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          user: widget.user,
          authService: widget.authService,
          bibleService: widget.bibleService,
          userProfileService: widget.userProfileService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadAll,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                  children: [
                    _Header(
                      greeting: (_profileName?.isNotEmpty ?? false)
                          ? 'Olá, $_profileName'
                          : widget.user.email,
                      onLogout: () => widget.authService.logout(),
                      onOpenSettings: _openSettings,
                      themeController: widget.themeController,
                    ),
                    const SizedBox(height: 20),
                    PanoramaCard(
                      panorama: _panorama,
                      targetDate: _targetDate,
                      onTargetDateChanged: _onTargetDateChanged,
                    ),
                    const SizedBox(height: 14),
                    _TodayPill(count: _todayReads.length),
                    const SizedBox(height: 14),
                    HistorySection(
                      history: _readingHistory,
                      totalReads: _reads.length,
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Seu livro',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedBook,
                      decoration: const InputDecoration(labelText: 'Livro'),
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
                    const SizedBox(height: 20),
                    ChapterGrid(
                      chapterCount: _selectedBookInfo.chapters,
                      isChapterRead: _isChapterRead,
                      togglingChapter: _togglingChapter,
                      onToggle: _toggleChapter,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.greeting,
    required this.onLogout,
    required this.onOpenSettings,
    required this.themeController,
  });

  final String? greeting;
  final VoidCallback onLogout;
  final VoidCallback onOpenSettings;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Complete Bible',
                style: textTheme.headlineSmall,
              ),
              if (greeting != null) ...[
                const SizedBox(height: 2),
                Text(
                  greeting!,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 8),
        ThemeToggleButton(themeController: themeController),
        const SizedBox(width: 8),
        IconButton(
          tooltip: 'Configurações',
          icon: const Icon(Icons.settings_outlined, size: 20),
          onPressed: onOpenSettings,
        ),
        const SizedBox(width: 4),
        IconButton(
          tooltip: 'Sair',
          icon: const Icon(Icons.logout_rounded, size: 20),
          onPressed: onLogout,
        ),
      ],
    );
  }
}

class _TodayPill extends StatelessWidget {
  const _TodayPill({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.today_rounded, size: 18, color: scheme.secondary),
          ),
          const SizedBox(width: 12),
          Text(
            count == 0
                ? 'Nenhum capítulo lido hoje'
                : 'Lido hoje: $count capítulo${count == 1 ? '' : 's'}',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
