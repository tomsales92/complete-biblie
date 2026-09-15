import 'package:flutter_test/flutter_test.dart';

import 'package:compute_bible/data/bible_data.dart';
import 'package:compute_bible/models/read_entry.dart';

void main() {
  test('buildPanorama counts unique read chapters', () {
    final reads = [
      const ReadEntry(id: 'Gênesis__1', book: 'Gênesis', chapter: 1, date: '2026-01-01'),
      const ReadEntry(id: 'Gênesis__2', book: 'Gênesis', chapter: 2, date: '2026-01-02'),
    ];

    final panorama = buildPanorama(reads, '2026-12-31');

    expect(panorama.readChapters, 2);
    expect(panorama.totalChapters, totalChapters);
    expect(panorama.remainingChapters, totalChapters - 2);
  });

  test('readDocId matches book and chapter', () {
    expect(readDocId('Gênesis', 1), 'Gênesis__1');
  });

  test('groupReadsByDate groups by day, newest first, sorted by readAt desc', () {
    final reads = [
      const ReadEntry(
        id: 'a',
        book: 'Gênesis',
        chapter: 1,
        date: '2026-01-01',
        readAt: '2026-01-01T08:00:00.000Z',
      ),
      const ReadEntry(
        id: 'b',
        book: 'Gênesis',
        chapter: 2,
        date: '2026-01-01',
        readAt: '2026-01-01T09:00:00.000Z',
      ),
      const ReadEntry(
        id: 'c',
        book: 'Êxodo',
        chapter: 1,
        date: '2026-01-02',
        readAt: '2026-01-02T08:00:00.000Z',
      ),
    ];

    final groups = groupReadsByDate(reads);

    expect(groups.length, 2);
    expect(groups[0].date, '2026-01-02');
    expect(groups[1].date, '2026-01-01');
    expect(groups[1].reads.map((r) => r.id).toList(), ['b', 'a']);
  });

  test('formatReadTime formats ISO timestamps as local HH:mm', () {
    expect(formatReadTime(null), '');
    expect(formatReadTime('not-a-date'), '');
    expect(formatReadTime('2026-01-01T00:00:00.000Z'), isNotEmpty);
  });
}
