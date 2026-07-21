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
    final colors = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Panorama',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () => _pickDate(context),
                  icon: const Icon(Icons.event, size: 18),
                  label: Text(
                    '${targetDate.day.toString().padLeft(2, '0')}/'
                    '${targetDate.month.toString().padLeft(2, '0')}/'
                    '${targetDate.year}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (p == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: (p.percentComplete / 100).clamp(0, 1),
                  minHeight: 10,
                  backgroundColor: colors.surfaceContainerHighest,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 20,
                runSpacing: 10,
                children: [
                  _Stat(label: 'Lidos', value: '${p.readChapters}/${p.totalChapters}'),
                  _Stat(label: 'Completo', value: '${p.percentComplete}%'),
                  _Stat(label: 'Faltam', value: '${p.remainingChapters}'),
                  _Stat(label: 'Dias restantes', value: '${p.daysRemaining}'),
                  _Stat(label: 'Capítulos/dia', value: '${p.chaptersPerDay}'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
