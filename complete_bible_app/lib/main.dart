import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'services/bible_service.dart';
import 'services/theme_controller.dart';
import 'services/user_profile_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final themeController = ThemeController();
  await themeController.load();

  runApp(BibleReadingApp(themeController: themeController));
}

class BibleReadingApp extends StatelessWidget {
  const BibleReadingApp({super.key, required this.themeController});

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Complete Bible',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeController.mode,
          home: AuthGate(
            authService: AuthService(),
            bibleService: BibleService(),
            userProfileService: UserProfileService(),
            themeController: themeController,
          ),
        );
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({
    super.key,
    required this.authService,
    required this.bibleService,
    required this.userProfileService,
    required this.themeController,
  });

  final AuthService authService;
  final BibleService bibleService;
  final UserProfileService userProfileService;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authService.userChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          return LoginScreen(
            authService: authService,
            themeController: themeController,
            userProfileService: userProfileService,
          );
        }

        return HomeScreen(
          user: user,
          authService: authService,
          bibleService: bibleService,
          userProfileService: userProfileService,
          themeController: themeController,
        );
      },
    );
  }
}
