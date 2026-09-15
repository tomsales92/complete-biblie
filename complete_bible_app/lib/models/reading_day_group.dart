import 'read_entry.dart';

class ReadingDayGroup {
  const ReadingDayGroup({
    required this.date,
    required this.label,
    required this.reads,
  });

  final String date;
  final String label;
  final List<ReadEntry> reads;
}
