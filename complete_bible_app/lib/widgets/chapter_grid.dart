import 'package:flutter/material.dart';

class ChapterGrid extends StatelessWidget {
  const ChapterGrid({
    super.key,
    required this.chapterCount,
    required this.isChapterRead,
    required this.togglingChapter,
    required this.onToggle,
  });

  final int chapterCount;
  final bool Function(int chapter) isChapterRead;
  final int? togglingChapter;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: chapterCount,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 56,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final chapter = index + 1;
        final isRead = isChapterRead(chapter);
        final isToggling = togglingChapter == chapter;

        return Material(
          color: isRead ? scheme.primary : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: togglingChapter == null ? () => onToggle(chapter) : null,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isToggling)
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: isRead ? scheme.onPrimary : scheme.primary,
                    ),
                  )
                else
                  Text(
                    '$chapter',
                    style: TextStyle(
                      color: isRead ? scheme.onPrimary : scheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                if (isRead && !isToggling)
                  Positioned(
                    top: 3,
                    right: 3,
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 12,
                      color: scheme.onPrimary.withValues(alpha: 0.85),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
