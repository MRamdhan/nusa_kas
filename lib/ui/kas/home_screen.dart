import 'package:flutter/material.dart';

import '../../domain/models/transaksi.dart';
import '../../utils/rupiah_formatter.dart';
import 'kas_view_model.dart';
import 'tambah_transaksi_screen.dart';

class HomeScreen extends StatelessWidget {
  final KasViewModel viewModel;

  const HomeScreen({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, child) {
        final daftarTransaksi = viewModel.transaksi;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'NusaKas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),

          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =========================
                // KARTU SALDO
                // =========================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Saldo Kas Saat Ini',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        formatRupiah(viewModel.saldo),
                        key: const Key('saldoText'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // =========================
                // RINGKASAN PEMASUKAN
                // DAN PENGELUARAN
                // =========================

                Row(
                  children: [
                    Expanded(
                      child: _summaryCard(
                        'Pemasukan',
                        viewModel.totalPemasukan,
                        Colors.green,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _summaryCard(
                        'Pengeluaran',
                        viewModel.totalPengeluaran,
                        Colors.red,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // =========================
                // JUDUL RIWAYAT TRANSAKSI
                // =========================

                const Text(
                  'Riwayat Transaksi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // =========================
                // DAFTAR TRANSAKSI
                // =========================

                Expanded(
                  child: daftarTransaksi.isEmpty
                      ? const Center(
                          child: Text(
                            'Belum ada transaksi',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: daftarTransaksi.length,
                          itemBuilder: (context, index) {
                            final item = daftarTransaksi[index];

                            final pemasukan =
                                item.jenis ==
                                    JenisTransaksi.pemasukan;

                            return Dismissible(
                              key: ValueKey(item.id),

                              direction:
                                  DismissDirection.endToStart,

                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(
                                  right: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),

                              onDismissed: (_) {
                                viewModel.hapusTransaksi(item.id);

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Transaksi berhasil dihapus',
                                    ),
                                  ),
                                );
                              },

                              child: Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: pemasukan
                                        ? Colors.green.shade100
                                        : Colors.red.shade100,

                                    child: Icon(
                                      pemasukan
                                          ? Icons.arrow_downward
                                          : Icons.arrow_upward,

                                      color: pemasukan
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),

                                  title: Text(
                                    item.keterangan,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  subtitle: Text(
                                    '${item.tanggal.day}/'
                                    '${item.tanggal.month}/'
                                    '${item.tanggal.year}',
                                  ),

                                  trailing: Text(
                                    '${pemasukan ? '+' : '-'}'
                                    '${formatRupiah(item.nominal)}',

                                    style: TextStyle(
                                      color: pemasukan
                                          ? Colors.green
                                          : Colors.red,

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),

          // =========================
          // TOMBOL TAMBAH TRANSAKSI
          // =========================

          floatingActionButton: FloatingActionButton(
            key: const Key('tambahTransaksiButton'),

            backgroundColor: Colors.green,
            foregroundColor: Colors.white,

            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TambahTransaksiScreen(
                    viewModel: viewModel,
                  ),
                ),
              );
            },

            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  // =========================
  // WIDGET RINGKASAN KAS
  // =========================

  Widget _summaryCard(
    String judul,
    double nominal,
    Color warna,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: warna.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            judul,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            formatRupiah(nominal),
            style: TextStyle(
              color: warna,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
