import 'package:flutter/material.dart';

import '../data/bible_data.dart';
import '../data/book_names.dart';
import '../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: ExpansionTile(
          shape: const RoundedRectangleBorder(side: BorderSide.none),
          collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
          tilePadding: const EdgeInsets.fromLTRB(24, 4, 20, 4),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.history_rounded,
              size: 20,
              color: scheme.secondary,
            ),
          ),
          title: Text(
            l10n.readingHistory,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(l10n.chaptersCount(totalReads)),
          childrenPadding: const EdgeInsets.fromLTRB(24, 0, 20, 20),
          children:
              history.isEmpty
                  ? [
                    Text(
                      l10n.noReadsYet,
                      style: TextStyle(color: scheme.onSurfaceVariant),
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
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: scheme.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                formatDateLabel(context, day.date),
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                l10n.chapAbbrev(day.reads.length),
                style: textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:
                  day.reads
                      .map(
                        (read) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${localizedBookName(context, read.book)} ${read.chapter}',
                              ),
                              if (formatReadTime(
                                context,
                                read.readAt,
                              ).isNotEmpty)
                                Text(
                                  formatReadTime(context, read.readAt),
                                  style: textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
