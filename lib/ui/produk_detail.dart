import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import untuk format mata uang
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_form.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/widget/warning_dialog.dart';

// Mendefinisikan warna utama agar konsisten
const Color _primaryColor = Color(0xFF6A1B9A); // Ungu Tua/Mewah
const Color _secondaryColor = Color(0xFFE1BEE7); // Ungu Muda
const Color _dangerColor = Color(0xFFC62828); // Merah untuk Hapus

class ProdukDetail extends StatefulWidget {
  final Produk? produk;

  const ProdukDetail({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  // Fungsi untuk memformat harga menjadi mata uang Rupiah
  String _formatCurrency(int price) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return format.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: _primaryColor, // Konsisten dengan Appbar lain
        foregroundColor: Colors.white,
        elevation: 8,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Informasi Produk
              Center(
                child: Text(
                  widget.produk!.namaProduk!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Detail Produk dalam Card yang elegan
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                        icon: Icons.qr_code,
                        label: "Kode Produk",
                        value: widget.produk!.kodeProduk!,
                        isHeader: true,
                      ),
                      const Divider(height: 25, thickness: 1),
                      _buildDetailRow(
                        icon: Icons.inventory_2_outlined,
                        label: "Nama Produk",
                        value: widget.produk!.namaProduk!,
                      ),
                      const Divider(height: 25, thickness: 1),
                      _buildDetailRow(
                        icon: Icons.payments_outlined,
                        label: "Harga",
                        value: _formatCurrency(widget.produk!.hargaProduk!),
                        isPrice: true,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),
              _tombolHapusEdit()
            ],
          ),
        ),
      ),
    );
  }

  // Widget Pembantu untuk Baris Detail
  Widget _buildDetailRow(
      {required IconData icon,
      required String label,
      required String value,
      bool isHeader = false,
      bool isPrice = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _primaryColor.withOpacity(0.8), size: 28),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                    fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: isHeader ? 20 : 18,
                  fontWeight: isPrice ? FontWeight.w900 : FontWeight.w600,
                  color: isPrice ? _primaryColor : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Tombol Hapus dan Edit yang Mewah dan Konsisten
  Widget _tombolHapusEdit() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Tombol EDIT
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.edit, size: 20),
              label: const Text("UBAH"),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProdukForm(
                      produk: widget.produk!,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 20),
        // Tombol DELETE
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.delete_forever, size: 20),
              label: const Text("HAPUS"),
              style: ElevatedButton.styleFrom(
                backgroundColor: _dangerColor, // Menggunakan warna merah untuk bahaya
                foregroundColor: Colors.white,
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () => confirmHapus(),
            ),
          ),
        ),
      ],
    );
  }

  // Dialog Konfirmasi Hapus yang lebih konsisten
  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text("Konfirmasi Hapus", style: TextStyle(color: _dangerColor)),
      content: const Text("Apakah Anda yakin ingin menghapus data produk ini secara permanen?"),
      actions: [
        TextButton(
          child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text("Hapus", style: TextStyle(color: _dangerColor, fontWeight: FontWeight.bold)),
          onPressed: () {
            ProdukBloc.deleteProduk(id: int.parse(widget.produk!.id!)).then(
                (value) => {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const ProdukPage()),
                          (Route<dynamic> route) => false) // Menggunakan pushAndRemoveUntil untuk kembali ke ProdukPage utama
                    }, onError: (error) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => const WarningDialog(
                        description: "Hapus gagal, silahkan coba lagi",
                      ));
            });
          },
        ),
      ],
    );

    showDialog(builder: (context) => alertDialog, context: context);
  }
}