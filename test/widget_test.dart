import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_ease/firebase_options.dart';
import 'package:home_ease/main.dart';

void main() {
  testWidgets('HomeEase app builds successfully', (WidgetTester tester) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await tester.pumpWidget(const HomeEaseApp());

    expect(find.byType(HomeEaseApp), findsOneWidget);
  });
}
