  import 'package:flutter/material.dart';
  import 'package:tokokita/bloc/login_bloc.dart';
  import 'package:tokokita/helpers/user_info.dart';
  import 'package:tokokita/ui/produk_page.dart';
  import 'package:tokokita/ui/registrasi_page.dart';
  import 'package:tokokita/widget/warning_dialog.dart';

  class LoginPage extends StatefulWidget {
    const LoginPage({Key? key}) : super(key: key);

    @override
    _LoginPageState createState() => _LoginPageState();
  }

  class _LoginPageState extends State<LoginPage> {
    final _formKey = GlobalKey<FormState>();
    bool _isLoading = false;

    final _emailTextboxController = TextEditingController();
    final _passwordTextboxController = TextEditingController();

    // Mendefinisikan warna utama agar konsisten dengan halaman Registrasi
    static const Color _primaryColor = Color(0xFF6A1B9A); // Ungu Tua/Mewah
    static const Color _secondaryColor = Color(0xFFE1BEE7); // Ungu Muda
    static const Color _accentColor = Color(0xFFFFC107); // Emas/Kuning Aksen

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Masuk ke Akun Anda'),
          // Konsistensi: Appbar transparan dan elevation 0
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: _primaryColor,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Logo atau Judul Utama yang lebih menawan (Konsisten dengan Registrasi)
                const Text(
                  "Selamat Datang Kembali",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Silahkan masukkan detail akun Anda",
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
                      _emailTextField(),
                      const SizedBox(height: 16),
                      _passwordTextField(),
                      const SizedBox(height: 40),
                      _buttonLogin(),
                      const SizedBox(height: 30),
                      _menuRegistrasi()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // --- Widget Input Decoration yang Konsisten ---

    InputDecoration _inputDecoration(String labelText, IconData icon) {
      return InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: _primaryColor.withOpacity(0.7)),
        labelStyle: const TextStyle(color: _primaryColor),
        floatingLabelStyle:
            const TextStyle(color: _primaryColor, fontWeight: FontWeight.bold),
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
        // Border saat di-enable
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: _primaryColor.withOpacity(0.3), width: 1),
        ),
        filled: true,
        fillColor: _secondaryColor.withOpacity(0.1),
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
          if (value!.isEmpty) {
            return "Password harus diisi";
          }
          return null;
        },
      );
    }

    // --- Widget Tombol Login yang Mewah dan Konsisten ---

    Widget _buttonLogin() {
      return SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor, // Warna background tombol utama
            foregroundColor: Colors.white,
            elevation: 10, // Bayangan tombol yang menonjol
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
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
              : const Text("MASUK"),
          onPressed: () {
            var validate = _formKey.currentState!.validate();
            if (validate) {
              if (!_isLoading) _submit();
            }
          },
        ),
      );
    }

    // --- Menu Registrasi yang Konsisten ---

    Widget _menuRegistrasi() {
      return Center(
        child: Column(
          children: [
            const Text(
              "Belum punya akun?",
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 8),
            InkWell(
              child: Text(
                "Daftar Sekarang",
                style: TextStyle(
                  color: _primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  decoration: TextDecoration.underline, // Memberi penekanan
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegistrasiPage()));
              },
            ),
          ],
        ),
      );
    }

    // --- Logika Submit ---

    void _submit() {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      LoginBloc.login(
              email: _emailTextboxController.text,
              password: _passwordTextboxController.text)
          .then((value) async {
        if (value.code == 200) {
          await UserInfo().setToken(value.token.toString());
          await UserInfo().setUserID(int.parse(value.userID.toString()));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const ProdukPage()));
        } else {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => const WarningDialog(
                    description: "Login gagal, silahkan periksa email dan kata sandi Anda.", // Pesan yang lebih spesifik
                  ));
        }
      }, onError: (error) {
        print(error);
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => const WarningDialog(
                  description: "Terjadi kesalahan. Gagal terhubung ke server.",
                ));
      }).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }