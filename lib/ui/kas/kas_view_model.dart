import 'package:flutter/foundation.dart';

import '../../domain/kas_calculator.dart';
import '../../domain/models/transaksi.dart';
import '../../data/repositories/transaksi_repository.dart';

class KasViewModel extends ChangeNotifier {
  final TransaksiRepository repository;
  final KasCalculator calculator;

  KasViewModel({
    TransaksiRepository? repository,
    KasCalculator? calculator,
  })  : repository = repository ?? TransaksiRepository(),
        calculator = calculator ?? KasCalculator();

  List<Transaksi> get transaksi => repository.getAll();

  double get totalPemasukan =>
      calculator.totalPemasukan(transaksi);

  double get totalPengeluaran =>
      calculator.totalPengeluaran(transaksi);

  double get saldo => calculator.hitungSaldo(transaksi);

  void tambahTransaksi({
    required String keterangan,
    required double nominal,
    required JenisTransaksi jenis,
  }) {
    calculator.validasiTransaksi(
      transaksi: transaksi,
      nominal: nominal,
      jenis: jenis,
    );

    final data = Transaksi(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      keterangan: keterangan,
      nominal: nominal,
      jenis: jenis,
      tanggal: DateTime.now(),
    );

    repository.tambah(data);
    notifyListeners();
  }

  void hapusTransaksi(String id) {
    repository.hapus(id);
    notifyListeners();
  }
}
