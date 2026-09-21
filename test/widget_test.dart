import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nama_project/main.dart';

void main() {
  testWidgets('login form validates phone and password', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Selamat Datang Kembali!'), findsOneWidget);
    expect(find.text('Lanjut sebagai Pengunjung'), findsOneWidget);
    await tester.tap(find.text('Masuk  →'));
    await tester.pump();

    expect(find.text('Nomor HP wajib diisi'), findsOneWidget);
    expect(find.text('Password minimal 6 karakter'), findsOneWidget);
  });

  testWidgets('successful login opens home screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextFormField).first, '81234567890');
    await tester.enterText(find.byType(TextFormField).last, 'password');
    await tester.tap(find.text('Masuk  →'));
    await tester.pump(const Duration(milliseconds: 950));
    await tester.pumpAndSettle();

    expect(find.text('Keunggulan CookBox'), findsOneWidget);
    expect(find.textContaining('Mau masak hari ini?'), findsOneWidget);
  });
}
