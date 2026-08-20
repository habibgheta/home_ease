import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:home_ease/firebase_options.dart';
import 'package:home_ease/screens/splash/splash_screen.dart';
import 'package:home_ease/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final preferences = await SharedPreferences.getInstance();

  final savedTheme = preferences.getString("themeMode");

  ThemeMode initialThemeMode;

  if (savedTheme == "dark") {
    initialThemeMode = ThemeMode.dark;
  } else {
    initialThemeMode = ThemeMode.light;
  }

  HomeEaseApp.themeMode.value = initialThemeMode;

  runApp(const HomeEaseApp());
}

class HomeEaseApp extends StatefulWidget {
  const HomeEaseApp({super.key});

  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(
    ThemeMode.light,
  );

  @override
  State<HomeEaseApp> createState() => _HomeEaseAppState();
}

class _HomeEaseAppState extends State<HomeEaseApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: HomeEaseApp.themeMode,
      builder: (context, themeMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'HomeEase',

          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,

          home: const SplashScreen(),
        );
      },
    );
  }
}
