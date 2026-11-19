import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// Format angka menjadi Rupiah Indonesia
String formatRupiah(num nominal) {
  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(nominal);
}

// Mengubah teks Rupiah menjadi angka
double parseRupiah(String value) {
  final angka = value.replaceAll(RegExp(r'[^0-9]'), '');

  if (angka.isEmpty) {
    return 0;
  }

  return double.parse(angka);
}

// Formatter otomatis untuk kolom nominal
class RupiahInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final angka = newValue.text.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    if (angka.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    final nominal = int.parse(angka);
    final hasil = _formatter.format(nominal);

    return TextEditingValue(
      text: hasil,
      selection: TextSelection.collapsed(
        offset: hasil.length,
      ),
    );
  }
}
