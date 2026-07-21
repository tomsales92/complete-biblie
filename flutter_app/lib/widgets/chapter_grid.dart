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
    final colors = Theme.of(context).colorScheme;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: chapterCount,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 56,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final chapter = index + 1;
        final isRead = isChapterRead(chapter);
        final isToggling = togglingChapter == chapter;

        return Material(
          color: isRead ? colors.primary : colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: togglingChapter == null ? () => onToggle(chapter) : null,
            child: Center(
              child: isToggling
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: isRead ? colors.onPrimary : colors.primary,
                      ),
                    )
                  : Text(
                      '$chapter',
                      style: TextStyle(
                        color: isRead ? colors.onPrimary : colors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
