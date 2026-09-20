import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/theme_controller.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key, required this.themeController});

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        final isDark = themeController.isDark;
        return IconButton(
          tooltip:
              isDark
                  ? AppLocalizations.of(context).lightTheme
                  : AppLocalizations.of(context).darkTheme,
          icon: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            size: 20,
          ),
          onPressed: () => themeController.setDark(!isDark),
        );
      },
    );
  }
}
