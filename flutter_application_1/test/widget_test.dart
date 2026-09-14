// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Calculadora soma dois números', (WidgetTester tester) async {
    tester.binding.platformDispatcher.views.first
      ..physicalSize = const Size(400, 900)
      ..devicePixelRatio = 1;
    addTearDown(() {
      tester.binding.platformDispatcher.views.first
        ..physicalSize = const Size(800, 600)
        ..devicePixelRatio = 1;
    });
    await tester.pumpWidget(const MyApp());

    expect(find.text('0'), findsNWidgets(2));

    await tester.tap(find.text('2'));
    await tester.tap(find.text('+'));
    await tester.tap(find.text('3'));
    await tester.tap(find.text('='));
    await tester.pump();

    expect(find.text('5'), findsNWidgets(2));
  });
}
