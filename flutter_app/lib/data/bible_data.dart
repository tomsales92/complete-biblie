import '../models/bible_book.dart';
import '../models/panorama.dart';
import '../models/read_entry.dart';
import '../models/reading_day_group.dart';

const List<BibleBook> bibleBooks = [
  BibleBook(name: 'Gênesis', chapters: 50),
  BibleBook(name: 'Êxodo', chapters: 40),
  BibleBook(name: 'Levítico', chapters: 27),
  BibleBook(name: 'Números', chapters: 36),
  BibleBook(name: 'Deuteronômio', chapters: 34),
  BibleBook(name: 'Josué', chapters: 24),
  BibleBook(name: 'Juízes', chapters: 21),
  BibleBook(name: 'Rute', chapters: 4),
  BibleBook(name: '1 Samuel', chapters: 31),
  BibleBook(name: '2 Samuel', chapters: 24),
  BibleBook(name: '1 Reis', chapters: 22),
  BibleBook(name: '2 Reis', chapters: 25),
  BibleBook(name: '1 Crônicas', chapters: 29),
  BibleBook(name: '2 Crônicas', chapters: 36),
  BibleBook(name: 'Esdras', chapters: 10),
  BibleBook(name: 'Neemias', chapters: 13),
  BibleBook(name: 'Ester', chapters: 10),
  BibleBook(name: 'Jó', chapters: 42),
  BibleBook(name: 'Salmos', chapters: 150),
  BibleBook(name: 'Provérbios', chapters: 31),
  BibleBook(name: 'Eclesiastes', chapters: 12),
  BibleBook(name: 'Cantares', chapters: 8),
  BibleBook(name: 'Isaías', chapters: 66),
  BibleBook(name: 'Jeremias', chapters: 52),
  BibleBook(name: 'Lamentações', chapters: 5),
  BibleBook(name: 'Ezequiel', chapters: 48),
  BibleBook(name: 'Daniel', chapters: 12),
  BibleBook(name: 'Oséias', chapters: 14),
  BibleBook(name: 'Joel', chapters: 3),
  BibleBook(name: 'Amós', chapters: 9),
  BibleBook(name: 'Obadias', chapters: 1),
  BibleBook(name: 'Jonas', chapters: 4),
  BibleBook(name: 'Miquéias', chapters: 7),
  BibleBook(name: 'Naum', chapters: 3),
  BibleBook(name: 'Habacuque', chapters: 3),
  BibleBook(name: 'Sofonias', chapters: 3),
  BibleBook(name: 'Ageu', chapters: 2),
  BibleBook(name: 'Zacarias', chapters: 14),
  BibleBook(name: 'Malaquias', chapters: 4),
  BibleBook(name: 'Mateus', chapters: 28),
  BibleBook(name: 'Marcos', chapters: 16),
  BibleBook(name: 'Lucas', chapters: 24),
  BibleBook(name: 'João', chapters: 21),
  BibleBook(name: 'Atos', chapters: 28),
  BibleBook(name: 'Romanos', chapters: 16),
  BibleBook(name: '1 Coríntios', chapters: 16),
  BibleBook(name: '2 Coríntios', chapters: 13),
  BibleBook(name: 'Gálatas', chapters: 6),
  BibleBook(name: 'Efésios', chapters: 6),
  BibleBook(name: 'Filipenses', chapters: 4),
  BibleBook(name: 'Colossenses', chapters: 4),
  BibleBook(name: '1 Tessalonicenses', chapters: 5),
  BibleBook(name: '2 Tessalonicenses', chapters: 3),
  BibleBook(name: '1 Timóteo', chapters: 6),
  BibleBook(name: '2 Timóteo', chapters: 4),
  BibleBook(name: 'Tito', chapters: 3),
  BibleBook(name: 'Filemom', chapters: 1),
  BibleBook(name: 'Hebreus', chapters: 13),
  BibleBook(name: 'Tiago', chapters: 5),
  BibleBook(name: '1 Pedro', chapters: 5),
  BibleBook(name: '2 Pedro', chapters: 3),
  BibleBook(name: '1 João', chapters: 5),
  BibleBook(name: '2 João', chapters: 1),
  BibleBook(name: '3 João', chapters: 1),
  BibleBook(name: 'Judas', chapters: 1),
  BibleBook(name: 'Apocalipse', chapters: 22),
];

final int totalChapters = bibleBooks.fold(0, (sum, book) => sum + book.chapters);

BibleBook? findBook(String name) {
  for (final book in bibleBooks) {
    if (book.name == name) return book;
  }
  return null;
}

String readDocId(String book, int chapter) => '${book}__$chapter';

String formatDate(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

String todayDateString() => formatDate(DateTime.now());

String _daysAgoDateString(int daysAgo) {
  return formatDate(DateTime.now().subtract(Duration(days: daysAgo)));
}

String formatDateLabel(String dateStr) {
  if (dateStr == todayDateString()) return 'Hoje';
  if (dateStr == _daysAgoDateString(1)) return 'Ontem';

  final parts = dateStr.split('-');
  return '${parts[2]}/${parts[1]}/${parts[0]}';
}

String formatReadTime(String? readAt) {
  if (readAt == null) return '';
  final parsed = DateTime.tryParse(readAt);
  if (parsed == null) return '';

  final local = parsed.toLocal();
  final h = local.hour.toString().padLeft(2, '0');
  final m = local.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

int _compareReads(ReadEntry a, ReadEntry b) {
  if (a.readAt != null && b.readAt != null) {
    return b.readAt!.compareTo(a.readAt!);
  }
  if (a.readAt != null) return -1;
  if (b.readAt != null) return 1;

  final indexA = bibleBooks.indexWhere((book) => book.name == a.book);
  final indexB = bibleBooks.indexWhere((book) => book.name == b.book);
  if (indexA != indexB) return indexA.compareTo(indexB);

  return a.chapter.compareTo(b.chapter);
}

List<ReadingDayGroup> groupReadsByDate(List<ReadEntry> reads) {
  final groups = <String, List<ReadEntry>>{};
  for (final read in reads) {
    groups.putIfAbsent(read.date, () => []).add(read);
  }

  final entries = groups.entries.toList()
    ..sort((a, b) => b.key.compareTo(a.key));

  return entries
      .map(
        (entry) => ReadingDayGroup(
          date: entry.key,
          label: formatDateLabel(entry.key),
          reads: [...entry.value]..sort(_compareReads),
        ),
      )
      .toList();
}

DateTime _parseTargetDate(String targetParam) {
  final parsed = DateTime.tryParse(targetParam);
  if (parsed != null) {
    return DateTime(parsed.year, parsed.month, parsed.day);
  }

  final year = DateTime.now().year;
  return DateTime(year, 12, 31);
}

int _daysBetween(DateTime start, DateTime end) {
  final diffMs = end.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
  final days = (diffMs / (1000 * 60 * 60 * 24)).ceil();
  return days < 0 ? 0 : days;
}

Panorama buildPanorama(List<ReadEntry> reads, String targetDate) {
  final uniqueReads = <String>{
    for (final read in reads) '${read.book}:${read.chapter}',
  };
  final readCount = uniqueReads.length;
  final remaining = totalChapters - readCount;
  final percentComplete = totalChapters == 0
      ? 0.0
      : (readCount / totalChapters * 1000).round() / 10;

  final today = DateTime.now();
  final todayOnly = DateTime(today.year, today.month, today.day);
  final target = _parseTargetDate(targetDate);
  final daysRemaining = _daysBetween(todayOnly, target);
  final chaptersPerDay = daysRemaining == 0
      ? remaining.toDouble()
      : (remaining / daysRemaining * 10).round() / 10;

  return Panorama(
    totalChapters: totalChapters,
    readChapters: readCount,
    remainingChapters: remaining,
    percentComplete: percentComplete,
    targetDate: formatDate(target),
    daysRemaining: daysRemaining,
    chaptersPerDay: chaptersPerDay,
  );
}
