import '../../domain/models/transaksi.dart';

class TransaksiRepository {
  final List<Transaksi> _transaksi = [];

  List<Transaksi> getAll() {
    return List.unmodifiable(_transaksi);
  }

  void tambah(Transaksi transaksi) {
    _transaksi.add(transaksi);
  }

  void hapus(String id) {
    _transaksi.removeWhere((item) => item.id == id);
  }
}
