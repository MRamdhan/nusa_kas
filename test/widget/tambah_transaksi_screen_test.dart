import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nusa_kas/domain/models/transaksi.dart';
import 'package:nusa_kas/ui/kas/kas_view_model.dart';
import 'package:nusa_kas/ui/kas/tambah_transaksi_screen.dart';

void main() {
  late KasViewModel viewModel;

  setUp(() {
    viewModel = KasViewModel();
  });

  tearDown(() {
    viewModel.dispose();
  });

  Widget buatWidget() {
    return MaterialApp(
      home: TambahTransaksiScreen(
        viewModel: viewModel,
      ),
    );
  }

  group('Tambah Transaksi Widget Test', () {

    // Test 1: Memastikan semua kolom tersedia
    testWidgets('Menampilkan form tambah transaksi',
        (WidgetTester tester) async {
      await tester.pumpWidget(buatWidget());

      expect(find.text('Tambah Transaksi'), findsOneWidget);
      expect(find.byKey(const Key('keteranganField')), findsOneWidget);
      expect(find.byKey(const Key('nominalField')), findsOneWidget);
      expect(find.byKey(const Key('jenisField')), findsOneWidget);
      expect(find.byKey(const Key('simpanButton')), findsOneWidget);
    });

    // Test 2: Memastikan transaksi berhasil ditambahkan
    testWidgets('Berhasil menyimpan transaksi pemasukan',
        (WidgetTester tester) async {
      await tester.pumpWidget(buatWidget());

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

      expect(viewModel.transaksi.length, 1);
      expect(viewModel.totalPemasukan, 100000);
      expect(
        viewModel.transaksi.first.keterangan,
        'Iuran anggota',
      );
      expect(
        viewModel.transaksi.first.jenis,
        JenisTransaksi.pemasukan,
      );
    });
  });
}
