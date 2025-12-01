import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import untuk format mata uang
import 'package:tokokita/bloc/logout_bloc.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/login_page.dart';
import 'package:tokokita/ui/produk_detail.dart';
import 'package:tokokita/ui/produk_form.dart';

// Mendefinisikan warna utama agar konsisten
const Color _primaryColor = Color(0xFF6A1B9A); // Ungu Tua/Mewah
const Color _secondaryColor = Color(0xFFE1BEE7); // Ungu Muda
const Color _accentColor = Color(0xFFFFC107); // Emas/Kuning Aksen
 
class ProdukPage extends StatefulWidget {
  const ProdukPage({Key? key}) : super(key: key);

  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Latar belakang abu-abu muda
      appBar: AppBar(
        title: const Text('Daftar Produk Premium'),
        backgroundColor: _primaryColor, // Appbar berwarna ungu tua
        foregroundColor: Colors.white,
        elevation: 8, // Elevation yang menonjol
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 28.0), // Ikon yang lebih detail
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProdukForm()));
              },
            ),
          )
        ],
      ),
      drawer: _buildDrawer(), // Memisahkan drawer ke fungsi terpisah
      body: FutureBuilder<List>(
        future: ProdukBloc.getProduks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: _primaryColor));
          }
          if (snapshot.hasError) {
            // Tampilan jika terjadi error
            return Center(
              child: Text("Gagal memuat data: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red)),
            );
          }
          if (snapshot.hasData && snapshot.data!.isEmpty) {
            // Tampilan jika data kosong
             return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 80, color: _primaryColor.withOpacity(0.5)),
                    const SizedBox(height: 16),
                    const Text(
                      "Belum ada produk.",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const Text(
                      "Tekan ikon '+' untuk menambahkannya.",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
            );
          }
          
          // Menampilkan List Produk
          return snapshot.hasData
              ? ListProduk(
                  list: snapshot.data,
                )
              : const Center(
                  child: CircularProgressIndicator(color: _primaryColor),
                );
        },
      ),
    );
  }

  // --- Drawer (Menu Samping) yang Konsisten dan Menawan ---
  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: Colors.white, // Latar belakang drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header Drawer Mewah
            const DrawerHeader(
              decoration: BoxDecoration(
                color: _primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 40),
                  SizedBox(height: 8),
                  Text(
                    'Manajemen Toko',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Item Logout
            ListTile(
              leading: const Icon(Icons.logout, color: _primaryColor),
              title: const Text(
                'Keluar (Logout)',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              // Tambahkan efek visual saat di-tap
              tileColor: Colors.transparent, 
              onTap: () async {
                await LogoutBloc.logout().then((value) => {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                          (route) => false)
                    });
              },
            ),
            const Divider(), // Garis pemisah yang elegan
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// Widget List Produk dan Item Produk
// ==========================================================

class ListProduk extends StatelessWidget {
  final List? list;
  const ListProduk({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0), // Padding di ListView
      itemCount: list == null ? 0 : list!.length,
      itemBuilder: (context, i) {
        return ItemProduk(
          produk: list![i],
        );
      },
    );
  }
}

class ItemProduk extends StatelessWidget {
  final Produk produk;
  const ItemProduk({Key? key, required this.produk}) : super(key: key);

  // Fungsi untuk memformat harga menjadi mata uang Rupiah
  String _formatCurrency(int price) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return format.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProdukDetail(
                      produk: produk,
                    )));
      },
      // Mengubah Card menjadi tampilan yang lebih mewah
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 6, // Bayangan yang lebih dalam
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Sudut membulat
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            // Border untuk aksen, menggunakan ungu muda
            border: Border.all(color: _secondaryColor, width: 1.5), 
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            leading: Icon(
              Icons.label_important_outline, // Ikon penanda produk
              color: _primaryColor,
              size: 30,
            ),
            title: Text(
              produk.namaProduk!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Kode: ${produk.kodeProduk!}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                // Menampilkan harga dengan format mata uang
                Text(
                  _formatCurrency(produk.hargaProduk!),
                  style: const TextStyle(
                    color: _primaryColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}