import 'package:flutter_test/flutter_test.dart';
import 'package:nusa_kas/domain/kas_calculator.dart';
import 'package:nusa_kas/domain/models/transaksi.dart';

void main() {
  late KasCalculator calculator;

  setUp(() {
    calculator = KasCalculator();
  });

  Transaksi buatTransaksi(
    String id,
    double nominal,
    JenisTransaksi jenis,
  ) {
    return Transaksi(
      id: id,
      keterangan: 'Transaksi $id',
      nominal: nominal,
      jenis: jenis,
      tanggal: DateTime(2026, 1, 1),
    );
  }

  group('KasCalculator Unit Test', () {

    // Test 1: Daftar transaksi kosong
    test('Total pemasukan daftar kosong adalah 0', () {
      expect(calculator.totalPemasukan([]), 0);
    });

    // Test 2: Total pengeluaran daftar kosong
    test('Total pengeluaran daftar kosong adalah 0', () {
      expect(calculator.totalPengeluaran([]), 0);
    });

    // Test 3: Saldo daftar kosong
    test('Saldo daftar kosong adalah 0', () {
      expect(calculator.hitungSaldo([]), 0);
    });

    // Test 4: Menghitung pemasukan
    test('Menghitung total pemasukan dengan benar', () {
      final data = [
        buatTransaksi('1', 100000, JenisTransaksi.pemasukan),
        buatTransaksi('2', 50000, JenisTransaksi.pemasukan),
      ];

      expect(calculator.totalPemasukan(data), 150000);
    });

    // Test 5: Menghitung pengeluaran
    test('Menghitung total pengeluaran dengan benar', () {
      final data = [
        buatTransaksi('1', 30000, JenisTransaksi.pengeluaran),
        buatTransaksi('2', 20000, JenisTransaksi.pengeluaran),
      ];

      expect(calculator.totalPengeluaran(data), 50000);
    });

    // Test 6: Menghitung saldo
    test('Menghitung saldo pemasukan dikurangi pengeluaran', () {
      final data = [
        buatTransaksi('1', 200000, JenisTransaksi.pemasukan),
        buatTransaksi('2', 50000, JenisTransaksi.pengeluaran),
      ];

      expect(calculator.hitungSaldo(data), 150000);
    });

    // Test 7: Pengeluaran tepat sama dengan saldo
    test('Pengeluaran sama dengan saldo diperbolehkan', () {
      final data = [
        buatTransaksi('1', 100000, JenisTransaksi.pemasukan),
      ];

      expect(
        () => calculator.validasiTransaksi(
          transaksi: data,
          nominal: 100000,
          jenis: JenisTransaksi.pengeluaran,
        ),
        returnsNormally,
      );
    });

    // Test 8: Pengeluaran melebihi saldo
    test('Pengeluaran melebihi saldo ditolak', () {
      final data = [
        buatTransaksi('1', 100000, JenisTransaksi.pemasukan),
      ];

      expect(
        () => calculator.validasiTransaksi(
          transaksi: data,
          nominal: 100001,
          jenis: JenisTransaksi.pengeluaran,
        ),
        throwsStateError,
      );
    });

    // Test 9: Nominal nol
    test('Nominal nol ditolak', () {
      expect(
        () => calculator.validasiTransaksi(
          transaksi: [],
          nominal: 0,
          jenis: JenisTransaksi.pemasukan,
        ),
        throwsArgumentError,
      );
    });

    // Test 10: Nominal negatif
    test('Nominal negatif ditolak', () {
      expect(
        () => calculator.validasiTransaksi(
          transaksi: [],
          nominal: -10000,
          jenis: JenisTransaksi.pemasukan,
        ),
        throwsArgumentError,
      );
    });

  });
}
