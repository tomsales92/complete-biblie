class Panorama {
  const Panorama({
    required this.totalChapters,
    required this.readChapters,
    required this.remainingChapters,
    required this.percentComplete,
    required this.targetDate,
    required this.daysRemaining,
    required this.chaptersPerDay,
  });

  final int totalChapters;
  final int readChapters;
  final int remainingChapters;
  final double percentComplete;
  final String targetDate;
  final int daysRemaining;
  final double chaptersPerDay;
}
