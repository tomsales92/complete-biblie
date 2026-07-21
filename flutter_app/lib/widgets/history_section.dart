import 'package:flutter/material.dart';

import '../data/bible_data.dart';
import '../models/reading_day_group.dart';

class HistorySection extends StatelessWidget {
  const HistorySection({
    super.key,
    required this.history,
    required this.totalReads,
  });

  final List<ReadingDayGroup> history;
  final int totalReads;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: const Text(
            'Histórico de leitura',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('$totalReads capítulos'),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          children: history.isEmpty
              ? const [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Nenhuma leitura registrada ainda.'),
                    ),
                  ),
                ]
              : history.map((day) => _HistoryDay(day: day)).toList(),
        ),
      ),
    );
  }
}

class _HistoryDay extends StatelessWidget {
  const _HistoryDay({required this.day});

  final ReadingDayGroup day;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                day.label,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('${day.reads.length} cap.', style: textTheme.bodySmall),
            ],
          ),
          const Divider(height: 16),
          ...day.reads.map(
            (read) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${read.book} ${read.chapter}'),
                  if (formatReadTime(read.readAt).isNotEmpty)
                    Text(formatReadTime(read.readAt), style: textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
