import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:home_ease/firebase_options.dart';
import 'package:home_ease/screens/auth/auth_wrapper.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.indigo,
              brightness: Brightness.dark,
            ),
            cardColor: const Color(0xFF1E1E1E),
            useMaterial3: true,
          ),

          themeMode: themeMode,

          home: const AuthWrapper(),
        );
      },
    );
  }
}
