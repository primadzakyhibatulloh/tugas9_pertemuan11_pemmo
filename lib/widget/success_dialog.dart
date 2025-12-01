import 'package:flutter/material.dart';

class Consts {
  Consts._();

  static const double padding = 20.0;
  static const double avatarRadius = 50.0; // Ukuran radius diseimbangkan
  static const Color successColor = Color(0xFF4CAF50);
  static const Color shadowColor = Color(0x30000000);
}

class SuccessDialog extends StatelessWidget {
  final String description;
  final VoidCallback? okClick;

  const SuccessDialog({
    Key? key,
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
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: <Widget>[
          dialogContent(context),
          _buildSuccessIcon(),
        ],
      ),
    );
  }

  // Widget Bagian Ikon Sukses
  Widget _buildSuccessIcon() {
    return const Positioned(
      top: 0,
      child: CircleAvatar(
        backgroundColor: Consts.successColor, // Lingkaran Hijau
        radius: Consts.avatarRadius,
        child: Icon(
          Icons.check_circle_outline,
          color: Colors.white,
          size: 60.0,
        ),
      ),
    );
  }

  // Widget Bagian Konten Kartu Putih
  Widget dialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        // PERBAIKAN PENTING:
        // Padding atas = Radius Ikon + Buffer (15.0).
        // Ini memastikan teks dimulai DI BAWAH area ikon.
        top: Consts.avatarRadius + 15.0, 
        bottom: Consts.padding,
        left: Consts.padding,
        right: Consts.padding,
      ),
      margin: const EdgeInsets.only(
        // Margin atas ini membuat kartu putih turun setengan dari ikon,
        // menciptakan efek ikon "duduk" di atas kartu.
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
          const Text(
            "BERHASIL!",
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
              color: Consts.successColor, // Teks Hijau
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15.0,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 30.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Consts.successColor, // Tombol Hijau
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
                "TUTUP",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}