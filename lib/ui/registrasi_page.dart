import 'package:flutter/material.dart';
// Asumsikan RegistrasiBloc, SuccessDialog, dan WarningDialog sudah tersedia
import 'package:tokokita/bloc/registrasi_bloc.dart';
import 'package:tokokita/widget/success_dialog.dart';
import 'package:tokokita/widget/warning_dialog.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);

  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  // Mendefinisikan warna utama untuk tampilan yang mewah
  static const Color _primaryColor = Color(0xFF6A1B9A); // Ungu Tua/Mewah
  static const Color _secondaryColor = Color(0xFFE1BEE7); // Ungu Muda
  static const Color _accentColor = Color(0xFFFFC107); // Emas/Kuning Aksen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Mengubah warna latar belakang untuk kesan yang lebih dalam/mewah
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Buat Akun Baru"),
        // Menghilangkan bayangan Appbar dan mengatur warna
        elevation: 0,
        backgroundColor: Colors.transparent, // Membuat Appbar transparan
        foregroundColor: _primaryColor, // Warna teks di Appbar
      ),
      body: Center( // Memusatkan konten di tengah layar
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Logo atau Judul Utama yang lebih menawan
              const Text(
                "Selamat Datang",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Daftar untuk mulai berbelanja",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _namaTextField(),
                    const SizedBox(height: 16),
                    _emailTextField(),
                    const SizedBox(height: 16),
                    _passwordTextField(),
                    const SizedBox(height: 16),
                    _passwordKonfirmasiTextField(),
                    const SizedBox(height: 40),
                    _buttonRegistrasi(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget TextField dengan Dekorasi Modern (Kesan Mewah) ---

  InputDecoration _inputDecoration(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(icon, color: _primaryColor.withOpacity(0.7)),
      labelStyle: const TextStyle(color: _primaryColor),
      floatingLabelStyle: const TextStyle(color: _primaryColor, fontWeight: FontWeight.bold),
      // Border yang lebih elegan (OutlineInputBorder)
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _secondaryColor),
      ),
      // Border saat fokus
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primaryColor, width: 2),
      ),
      // Border saat ada error
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      // Border saat di-enable
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _primaryColor.withOpacity(0.3), width: 1),
      ),
      filled: true,
      fillColor: _secondaryColor.withOpacity(0.1), // Sedikit latar belakang pada input
    );
  }

  Widget _namaTextField() {
    return TextFormField(
      decoration: _inputDecoration("Nama Lengkap", Icons.person_outline),
      keyboardType: TextInputType.text,
      controller: _namaTextboxController,
      validator: (value) {
        if (value!.length < 3) {
          return "Nama harus diisi minimal 3 karakter";
        }
        return null;
      },
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      decoration: _inputDecoration("Alamat Email", Icons.email_outlined),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern.toString());
        if (!regex.hasMatch(value)) {
          return "Email tidak valid";
        }
        return null;
      },
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      decoration: _inputDecoration("Kata Sandi", Icons.lock_outline),
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value!.length < 6) {
          return "Kata Sandi harus diisi minimal 6 karakter";
        }
        return null;
      },
    );
  }

  Widget _passwordKonfirmasiTextField() {
    return TextFormField(
      decoration: _inputDecoration("Konfirmasi Kata Sandi", Icons.check_circle_outline),
      keyboardType: TextInputType.text,
      obscureText: true,
      validator: (value) {
        if (value != _passwordTextboxController.text) {
          return "Konfirmasi Kata Sandi tidak sama";
        }
        return null;
      },
    );
  }

  // --- Widget Tombol dengan Desain Mewah ---

  Widget _buttonRegistrasi() {
    return SizedBox(
      width: double.infinity, // Membuat tombol full width
      height: 55, // Mengatur tinggi tombol
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor, // Warna background tombol utama
          foregroundColor: Colors.white, // Warna teks tombol
          elevation: 10, // Bayangan tombol yang lebih menonjol
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Sudut tombol
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : const Text("DAFTAR SEKARANG"),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) _submit();
          }
        },
      ),
    );
  }

  // --- Logika Submit Tetap Sama ---

  void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    // Asumsikan RegistrasiBloc.registrasi adalah fungsi async
    RegistrasiBloc.registrasi(
            nama: _namaTextboxController.text,
            email: _emailTextboxController.text,
            password: _passwordTextboxController.text)
        .then((value) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SuccessDialog(
                description: "Registrasi berhasil, silahkan login",
                okClick: () {
                  Navigator.pop(context);
                  // Tambahkan logika navigasi ke halaman login di sini
                },
              ));
    }, onError: (error) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
                description: "Registrasi gagal, silahkan coba lagi",
              ));
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }
}