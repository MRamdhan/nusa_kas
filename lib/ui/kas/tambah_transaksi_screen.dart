import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/models/transaksi.dart';
import '../../utils/rupiah_formatter.dart';
import 'kas_view_model.dart';

class TambahTransaksiScreen extends StatefulWidget {
  final KasViewModel viewModel;

  const TambahTransaksiScreen({
    super.key,
    required this.viewModel,
  });

  @override
  State<TambahTransaksiScreen> createState() =>
      _TambahTransaksiScreenState();
}

class _TambahTransaksiScreenState
    extends State<TambahTransaksiScreen> {
  // GlobalKey untuk validasi form
  final _formKey = GlobalKey<FormState>();

  // Controller input
  final _keteranganController = TextEditingController();
  final _nominalController = TextEditingController();

  // Jenis transaksi default
  JenisTransaksi _jenis = JenisTransaksi.pemasukan;

  @override
  void dispose() {
    _keteranganController.dispose();
    _nominalController.dispose();
    super.dispose();
  }

  // =====================================
  // FUNGSI SIMPAN TRANSAKSI
  // =====================================

  void _simpanTransaksi() {
    // Memeriksa validasi form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Mengubah format Rupiah menjadi angka
    final nominal = parseRupiah(
      _nominalController.text,
    );

    try {
      widget.viewModel.tambahTransaksi(
        keterangan: _keteranganController.text.trim(),
        nominal: nominal,
        jenis: _jenis,
      );

      // Menampilkan pesan berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Transaksi berhasil disimpan',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Kembali ke halaman utama
      Navigator.pop(context);

    } on ArgumentError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message.toString()),
          backgroundColor: Colors.red,
        ),
      );

    } on StateError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // =====================================
      // APP BAR
      // =====================================

      appBar: AppBar(
        title: const Text(
          'Tambah Transaksi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      // =====================================
      // FORM TAMBAH TRANSAKSI
      // =====================================

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // =====================================
              // INPUT KETERANGAN
              // =====================================

              const Text(
                'Keterangan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                key: const Key('keteranganField'),
                controller: _keteranganController,

                decoration: const InputDecoration(
                  hintText: 'Contoh: Iuran anggota',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Keterangan wajib diisi';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // =====================================
              // INPUT NOMINAL
              // =====================================

              const Text(
                'Nominal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                key: const Key('nominalField'),
                controller: _nominalController,

                keyboardType: TextInputType.number,

                // Format otomatis Rupiah
                inputFormatters: [
                  RupiahInputFormatter(),
                ],

                decoration: const InputDecoration(
                  hintText: 'Contoh: Rp 100.000',
                  prefixIcon: Icon(Icons.payments),
                  border: OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Nominal wajib diisi';
                  }

                  // Mengubah format Rupiah menjadi angka
                  final angka = parseRupiah(value);

                  if (angka <= 0) {
                    return 'Nominal harus lebih dari nol';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // =====================================
              // PILIH JENIS TRANSAKSI
              // =====================================

              const Text(
                'Jenis Transaksi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 8),

              DropdownButtonFormField<JenisTransaksi>(
                key: const Key('jenisField'),

                initialValue: _jenis,

                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),

                items: const [
                  DropdownMenuItem(
                    value: JenisTransaksi.pemasukan,
                    child: Text('Pemasukan'),
                  ),

                  DropdownMenuItem(
                    value: JenisTransaksi.pengeluaran,
                    child: Text('Pengeluaran'),
                  ),
                ],

                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _jenis = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 30),

              // =====================================
              // TOMBOL SIMPAN
              // =====================================

              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  key: const Key('simpanButton'),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  onPressed: _simpanTransaksi,

                  child: const Text(
                    'Simpan Transaksi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
