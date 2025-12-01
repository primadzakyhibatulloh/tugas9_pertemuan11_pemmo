import 'package:flutter/material.dart';

class Consts {
  Consts._();

  static const double padding = 20.0;
  static const double avatarRadius = 50.0; // Ukuran radius ikon
  static const Color warningColor = Color(0xFFFF9800); // Warna Oranye Peringatan
  static const Color shadowColor = Color(0x30000000);
}

class WarningDialog extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? okClick;

  const WarningDialog({
    Key? key,
    this.title = "PERHATIAN!",
    required this.description,
    this.okClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none, // Memastikan bayangan atau elemen luar tidak terpotong
        alignment: Alignment.topCenter,
        children: <Widget>[
          dialogContent(context),
          _buildWarningIcon(), // Ikon diletakkan di atas (Stack urutan terakhir)
        ],
      ),
    );
  }

  // Widget Bagian Ikon
  Widget _buildWarningIcon() {
    return const Positioned(
      top: 0, // Posisi ikon di paling atas Stack
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: Consts.avatarRadius,
        child: Icon(
          Icons.warning_amber_rounded,
          color: Consts.warningColor,
          size: 60.0, // Ukuran ikon di dalam lingkaran
        ),
      ),
    );
  }

  // Widget Bagian Konten Kartu Putih
  Widget dialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        // PERBAIKAN DI SINI:
        // Padding atas = Radius Ikon + Jarak Tambahan.
        // Ini memastikan teks dimulai DI BAWAH ikon, bukan di belakangnya.
        top: Consts.avatarRadius + 15.0, 
        bottom: Consts.padding,
        left: Consts.padding,
        right: Consts.padding,
      ),
      margin: const EdgeInsets.only(
        // Margin atas membuat kartu putih mulai dari TENGAH ikon
        // sehingga ikon terlihat "mengapung" setengah di luar, setengah di dalam.
        top: Consts.avatarRadius, 
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(Consts.padding),
        boxShadow: const [
          BoxShadow(
            color: Consts.shadowColor,
            blurRadius: 20.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0, // Menambah jarak antar huruf agar lebih elegan
              color: Consts.warningColor,
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15.0,
              color: Colors.black54, // Warna teks abu-abu gelap agar nyaman dibaca
              height: 1.4, // Spasi antar baris
            ),
          ),
          const SizedBox(height: 30.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Consts.warningColor,
                foregroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14.0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                okClick?.call();
              },
              child: const Text(
                "SAYA MENGERTI",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}