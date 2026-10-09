import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nama_project/models/item.dart';
import 'package:nama_project/routes/app_routes.dart';
import 'package:nama_project/screens/detail_menu_screen.dart';
import 'package:nama_project/screens/home_screen.dart';

void main() {
  testWidgets('complete menu information is visible in detail screen', (
    WidgetTester tester,
  ) async {
    const item = Item(
      id: 'test',
      title: 'Ayam Geprek Sambal Korek',
      subtitle: 'Ayam, sambal korek, nasi',
      description: 'Paket ayam geprek dengan sambal korek.',
      merchantName: 'Dapur Bu Tini',
      category: 'Paket Masak',
      price: 18000,
      cookingDuration: '25 menit',
      storageDuration: '3 hari di suhu rendah',
      freshnessNote: 'Bahan segar & higienis',
      additionalMenu: ['Bebidas air putih', 'Sambal buat teman'],
      recommendedItemId: '2',
      recommendedMenu: 'Cah Kangkung Terasi',
      recommendedMerchantName: 'Pasar Segar Bu Sari',
    );
    await tester.pumpWidget(MaterialApp(home: DetailMenuScreen(item: item)));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Durasi memasak'),
      5000,
      scrollable: find.byType(Scrollable).last,
    );

    expect(find.text('Durasi memasak'), findsOneWidget);
    expect(find.text('Jangka simpan'), findsOneWidget);
    expect(find.text('Bahan segar & higienis'), findsOneWidget);
    expect(find.text('Menu tambahan'), findsOneWidget);
    expect(find.text('Rekomendasi menu'), findsOneWidget);
    expect(find.text('Cah Kangkung Terasi'), findsOneWidget);
    expect(find.text('Pasar Segar Bu Sari'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('recommended-menu-image')),
      findsOneWidget,
    );
  });

  testWidgets('selected catalog item opens matching detail and returns', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const HomeScreen(),
        onGenerateRoute: AppRoutes.onGenerateRoute,
        onUnknownRoute: AppRoutes.onUnknownRoute,
      ),
    );
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    final selectedMenu = find.text('Ayam Geprek Sambal Korek').first;
    await tester.ensureVisible(selectedMenu);
    await tester.tap(selectedMenu);
    await tester.pumpAndSettle();

    expect(find.text('Detail Menu'), findsOneWidget);
    expect(find.text('Ayam Geprek Sambal Korek'), findsOneWidget);
    expect(find.text('Rp 18.000'), findsNWidgets(2));
    expect(find.text('Dapur Bu Tini'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Ayam'),
      180,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Ayam'), findsOneWidget);
    expect(find.byKey(const ValueKey('detail-add')), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const ValueKey('detail-add')))
          .onPressed,
      isNull,
    );

    await tester.tap(find.byKey(const ValueKey('detail-back')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Paket Bahan Terlaris'),
      -180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Paket Bahan Terlaris'), findsOneWidget);
  });
}
