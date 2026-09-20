import 'read_entry.dart';

class ReadingDayGroup {
  const ReadingDayGroup({required this.date, required this.reads});

  final String date;
  final List<ReadEntry> reads;
}
