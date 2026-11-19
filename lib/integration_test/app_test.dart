import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:nusa_kas/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Menambahkan dua transaksi dan memeriksa saldo',
    (WidgetTester tester) async {

      await tester.pumpWidget(const NusaKasApp());
      await tester.pumpAndSettle();

      // Memastikan halaman utama tampil
      expect(find.text('NusaKas'), findsOneWidget);

      // =====================================
      // TRANSAKSI PERTAMA: PEMASUKAN 100000
      // =====================================

      await tester.tap(
        find.byKey(const Key('tambahTransaksiButton')),
      );

      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('keteranganField')),
        'Iuran anggota',
      );

      await tester.enterText(
        find.byKey(const Key('nominalField')),
        '100000',
      );

      await tester.tap(
        find.byKey(const Key('simpanButton')),
      );

      await tester.pumpAndSettle();

      // Memastikan saldo menjadi 100000
      expect(
        find.text('Rp 100000'),
        findsOneWidget,
      );

      // =====================================
      // TRANSAKSI KEDUA: PENGELUARAN 30000
      // =====================================

      await tester.tap(
        find.byKey(const Key('tambahTransaksiButton')),
      );

      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('keteranganField')),
        'Pembelian ATK',
      );

      await tester.enterText(
        find.byKey(const Key('nominalField')),
        '30000',
      );

      // Memilih jenis pengeluaran
      await tester.tap(
        find.byKey(const Key('jenisField')),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.text('Pengeluaran').last,
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('simpanButton')),
      );

      await tester.pumpAndSettle();

      // =====================================
      // MEMERIKSA SALDO AKHIR
      // =====================================

      expect(
        find.text('Rp 70000'),
        findsOneWidget,
      );

      expect(find.text('Iuran anggota'), findsOneWidget);
      expect(find.text('Pembelian ATK'), findsOneWidget);
    },
  );
}
