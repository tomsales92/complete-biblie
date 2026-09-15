import 'package:flutter/material.dart';

import '../models/panorama.dart';

class PanoramaCard extends StatelessWidget {
  const PanoramaCard({
    super.key,
    required this.panorama,
    required this.targetDate,
    required this.onTargetDateChanged,
  });

  final Panorama? panorama;
  final DateTime targetDate;
  final ValueChanged<DateTime> onTargetDateChanged;

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: targetDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    if (picked != null) {
      onTargetDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = panorama;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PANORAMA',
                  style: textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                InkWell(
                  onTap: () => _pickDate(context),
                  borderRadius: BorderRadius.circular(100),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.flag_rounded,
                          size: 15,
                          color: scheme.secondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${targetDate.day.toString().padLeft(2, '0')}/'
                          '${targetDate.month.toString().padLeft(2, '0')}/'
                          '${targetDate.year}',
                          style: textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (p == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              Center(child: _ProgressRing(percent: p.percentComplete)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      icon: Icons.menu_book_rounded,
                      value: '${p.readChapters}/${p.totalChapters}',
                      label: 'Lidos',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.hourglass_bottom_rounded,
                      value: '${p.remainingChapters}',
                      label: 'Faltam',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      icon: Icons.speed_rounded,
                      value: '${p.chaptersPerDay}',
                      label: 'Cap./dia',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatTile(
                      icon: Icons.calendar_today_rounded,
                      value: '${p.daysRemaining}',
                      label: 'Dias restantes',
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.percent});

  final double percent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 148,
      height: 148,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 148,
            height: 148,
            child: CircularProgressIndicator(
              value: (percent / 100).clamp(0, 1),
              strokeWidth: 12,
              strokeCap: StrokeCap.round,
              backgroundColor: scheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(scheme.primary),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${percent.toStringAsFixed(percent % 1 == 0 ? 0 : 1)}%',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'concluído',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: scheme.secondary),
          const SizedBox(height: 8),
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
