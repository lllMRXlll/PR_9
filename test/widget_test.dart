// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:flutter_application_9/app/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: tempDir,
    );
  });

  tearDown(() async {});

  testWidgets('App shows auth screen when not authenticated', (tester) async {
    await tester.pumpWidget(const AutoCatalogApp());
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Авторизация'), findsOneWidget);
    expect(find.text('Войти'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
  });
}
