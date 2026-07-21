class ReadEntry {
  const ReadEntry({
    required this.id,
    required this.book,
    required this.chapter,
    required this.date,
    this.readAt,
  });

  factory ReadEntry.fromMap(Map<String, dynamic> map) => ReadEntry(
    id: map['id'] as String,
    book: map['book'] as String,
    chapter: (map['chapter'] as num).toInt(),
    date: map['date'] as String,
    readAt: map['readAt'] as String?,
  );

  final String id;
  final String book;
  final int chapter;
  final String date;
  final String? readAt;

  Map<String, dynamic> toMap() => {
    'id': id,
    'book': book,
    'chapter': chapter,
    'date': date,
    if (readAt != null) 'readAt': readAt,
  };
}
