<div align="center">

<img src="https://www.google.com/search?q=https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png" alt="logo" width="100" height="auto" />

<h1>DOKUMENTASI REGISTRASI: TOKOKITA</h1>

<p>
Dokumentasi teknis mendalam mengenai implementasi fitur <strong>Pendaftaran Pengguna Baru</strong> pada aplikasi TokoKita.
<br />
Menggunakan <strong>Flutter</strong>, Validasi Form, dan Manajemen State <strong>BLoC</strong>.
</p>

</div>

<hr />

1. 📝 Proses Registrasi (Pendaftaran Akun)

Fitur ini adalah gerbang awal bagi pengguna baru. Alur kerjanya dirancang untuk memastikan data valid di sisi klien sebelum dikirim ke server, serta memberikan umpan balik visual yang elegan setelah proses selesai.

<table>
<tr>
<td width="30%">
<!-- GANTI DENGAN LINK/PATH GAMBAR SS REGISTRASI ANDA -->
<img width="390" height="828" alt="register-form-isi" src="https://github.com/user-attachments/assets/354b7c0e-5e8c-49e0-b4e4-5b406c69cbf2" />


</td>
<td width="70%">

a. Pengisian Form & Validasi Input

Pengguna diwajibkan mengisi Nama Lengkap, Email, Password, dan Konfirmasi Password.

Analisis Validasi Kode:
Validasi dilakukan secara real-time di lib/ui/registrasi_page.dart. Widget TextFormField menggunakan properti validator dengan logika berikut:

Nama: Minimal 3 karakter.

Email: Format email valid (menggunakan Regex).

Password: Minimal 6 karakter.

Konfirmasi Password: Harus identik dengan input Password utama.

<details>
<summary><b>🔻 Lihat Kode Validasi Password (Klik Disini)</b></summary>

// lib/ui/registrasi_page.dart

Widget _passwordKonfirmasiTextField() {
  return TextFormField(
    decoration: _inputDecoration("Konfirmasi Kata Sandi", Icons.check_circle_outline),
    obscureText: true,
    validator: (value) {
      // Memastikan input sama persis dengan controller password utama
      if (value != _passwordTextboxController.text) {
        return "Konfirmasi Kata Sandi tidak sama";
      }
      return null;
    },
  );
}


</details>
</td>
</tr>

<tr>
<td width="30%">
<!-- TEMPAT GAMBAR/DIAGRAM ALUR REQUEST -->
<img width="2048" height="2048" alt="Gemini_Generated_Image_1n46pk1n46pk1n46" src="https://github.com/user-attachments/assets/ad241d35-8501-4be4-a751-926f97d76b3c" />
</td>
<td width="70%">

b. Logika Bisnis & Request API (BLoC)

Setelah validasi sukses, tombol "DAFTAR SEKARANG" akan memicu pengiriman data.

Alur Data:

UI: Mengirim nama, email, password ke BLoC.

BLoC: Membungkus data ke dalam Map (JSON) dan memanggil Helper API.

API Helper: Menyuntikkan header (jika perlu) dan melakukan POST ke endpoint /registrasi.

Model: Hasil respons di-parse menjadi objek Registrasi.

<details>
<summary><b>🔻 Lihat Kode Registrasi BLoC</b></summary>

// lib/bloc/registrasi_bloc.dart

static Future<Registrasi> registrasi({String? nama, String? email, String? password}) async {
  String apiUrl = ApiUrl.registrasi; // Endpoint: /registrasi
  
  var body = {
    "nama": nama, 
    "email": email, 
    "password": password
  };
  
  // Mengirim Request POST
  var response = await Api().post(apiUrl, body); // Request dikirim via Api Helper
  
  // Konversi JSON ke Model Registrasi
  return Registrasi.fromJson(json.decode(response.body));
}


</details>
</td>
</tr>


<tr>
<td width="30%">
<!-- GANTI DENGAN LINK/PATH GAMBAR POPUP SUKSES ANDA -->
<img width="377" height="836" alt="register-berhasil" src="https://github.com/user-attachments/assets/3dad9063-8d57-45d4-a5bf-8828ee25230a" />
</td>
<td width="70%">

c. Feedback Sukses (Custom Widget)

Jika server merespon dengan kode 200 (OK), aplikasi menampilkan SuccessDialog.

Analisis Widget (SuccessDialog):
Dialog ini dibuat kustom agar terlihat lebih premium dibandingkan AlertDialog bawaan Flutter.

Teknik Desain: Menggunakan Stack untuk menumpuk elemen.

Layering:

Kartu Putih: Container dengan sudut membulat dan bayangan.

Ikon Hijau: CircleAvatar yang diposisikan di layer teratas (Positioned atau urutan terakhir di Stack) dengan margin atas negatif (visual) atau manipulasi padding konten agar terlihat "mengapung".

<details>
<summary><b>🔻 Lihat Kode Widget Dialog</b></summary>

// lib/widget/success_dialog.dart

child: Stack(
  clipBehavior: Clip.none, // Mengizinkan elemen keluar dari batas stack
  alignment: Alignment.topCenter,
  children: <Widget>[
    dialogContent(context), // Konten Kartu Putih (Layer Bawah)
    _buildSuccessIcon(),    // Ikon Centang Hijau (Layer Atas)
  ],
),


</details>

Navigasi:
Setelah dialog ditutup, pengguna diarahkan kembali ke halaman Login menggunakan Navigator.pop(context).

</td>
</tr>
</table>

<div align="center">
<small>Dikembangkan untuk Tugas Pertemuan 11 - Pemrograman Mobile 2</small>
</div>


2. 🔐 Proses Login (Otentikasi Pengguna)

Setelah berhasil mendaftar, pengguna harus masuk untuk mendapatkan Token Akses. Proses ini melibatkan pertukaran kredensial dengan server dan penyimpanan sesi aman di perangkat lokal.

<table>
<tr>
<td width="30%">
<!-- GANTI DENGAN LINK/PATH GAMBAR SS LOGIN ANDA -->
<img width="395" height="900" alt="login" src="https://github.com/user-attachments/assets/18b9e1c3-221d-4cf0-86ff-cc7b66e2cbbd" />
</td>
<td width="70%">

a. Input Kredensial & Validasi UI

Pengguna memasukkan Email dan Password.

Analisis Validasi Kode:
Validasi dilakukan menggunakan GlobalKey<FormState>. Sebelum request dikirim, fungsi validate() memastikan:

Email: Tidak boleh kosong.

Password: Tidak boleh kosong.

Jika validasi lolos, tombol Login akan memanggil fungsi _submit() dan menampilkan indikator loading.

<details>
<summary><b>🔻 Lihat Kode Tombol Login (Klik Disini)</b></summary>

// lib/ui/login_page.dart

Widget _buttonLogin() {
  return ElevatedButton(
    child: _isLoading
        ? const CircularProgressIndicator(color: Colors.white)
        : const Text("MASUK"),
    onPressed: () {
      var validate = _formKey.currentState!.validate();
      // Mencegah double-click saat loading
      if (validate && !_isLoading) {
        _submit();
      }
    },
  );
}


</details>
</td>
</tr>

<tr>
<td width="30%">
<!-- GANTI DENGAN LINK/PATH GAMBAR DIAGRAM/API ANDA -->
<img width="2048" height="2048" alt="Gemini_Generated_Image_1qnajq1qnajq1qna" src="https://github.com/user-attachments/assets/bd51380c-6df6-4845-8b0e-0c8a9ec826e7" />
</td>
<td width="70%">

b. Logika Bisnis (BLoC) & Request API

Data dikirim ke server untuk diverifikasi.

Alur Data:

LoginBloc: Menerima email & password.

API Helper: Melakukan POST ke endpoint /login.

Model: Respons JSON (yang berisi Token dan User Info) dikonversi menjadi objek Login.

<details>
<summary><b>🔻 Lihat Kode Login BLoC</b></summary>

// lib/bloc/login_bloc.dart

static Future<Login> login({String? email, String? password}) async {
  String apiUrl = ApiUrl.login;
  
  var body = {
    "email": email, 
    "password": password
  };
  
  var response = await Api().post(apiUrl, body);
  return Login.fromJson(json.decode(response.body));
}


</details>
</td>
</tr>

<tr>
<td width="30%">
<!-- GANTI DENGAN LINK/PATH GAMBAR HALAMAN PRODUK (TUJUAN) ANDA -->
<img width="368" height="827" alt="login-form-isi" src="https://github.com/user-attachments/assets/aaebfc55-199f-45bf-86e4-42b27037ec96" />

</td>
<td width="70%">

c. Sukses: Penyimpanan Sesi & Navigasi

Jika server merespon dengan Code 200, login dianggap sukses.

Manajemen Sesi (UserInfo):
Aplikasi menyimpan Token dan UserID ke dalam penyimpanan lokal (SharedPreferences). Ini krusial agar pengguna tetap login meskipun aplikasi ditutup.

Navigasi:
Menggunakan pushReplacement untuk berpindah ke ProdukPage. Ini mencegah pengguna kembali ke halaman Login saat menekan tombol Back.

<details>
<summary><b>🔻 Lihat Kode Penanganan Sukses</b></summary>

// lib/ui/login_page.dart -> _submit()

if (value.code == 200) {
  // 1. Simpan Token & ID ke Shared Preferences
  await UserInfo().setToken(value.token.toString());
  await UserInfo().setUserID(int.parse(value.userID.toString()));
  
  // 2. Tampilkan Feedback Sukses (Opsional)
  await showDialog(... SuccessDialog ...);

  // 3. Pindah ke Halaman Utama
  Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) => const ProdukPage()));
}


</details>
</td>
</tr>

<tr>
<td width="30%">
<!-- GANTI DENGAN LINK/PATH GAMBAR WARNING DIALOG ANDA -->
<img width="385" height="840" alt="login-gagal" src="https://github.com/user-attachments/assets/09ca7194-3cdf-4bbf-9c5f-f2dcad1270ff" />

</td>
<td width="70%">

d. Gagal: Feedback Error (WarningDialog)

Jika kredensial salah atau server bermasalah, aplikasi menampilkan WarningDialog.

Skenario Error:

API Error (Code != 200): Pesan "Login gagal, silahkan periksa email dan kata sandi".

Exception (onError): Pesan "Gagal terhubung ke server" (misal: internet mati).

<details>
<summary><b>🔻 Lihat Kode Penanganan Error</b></summary>

// lib/ui/login_page.dart -> else / onError

} else {
  showDialog(
    context: context,
    builder: (BuildContext context) => const WarningDialog(
      description: "Login gagal, silahkan periksa email dan kata sandi Anda.",
    ));
}
// onError: Menangani masalah koneksi


</details>
</td>
</tr>
</table>

3. ➕ Proses Tambah Produk (Create Data)

Fitur ini memungkinkan pengguna untuk menambahkan data produk baru ke server. Kami menggunakan pendekatan Single Form di mana satu file UI (ProdukForm) dapat menangani baik penambahan maupun pengubahan data.

<table>
<tr>
<td width="30%">
<!-- GANTI DENGAN LINK/PATH GAMBAR SS FORM TAMBAH KOSONG ANDA -->
<img width="343" height="830" alt="tambah-produk" src="https://github.com/user-attachments/assets/cae5f864-d777-4f05-b354-ea20e880a941" />
</td>
<td width="70%">

a. Inisialisasi Form (Mode Tambah)

Saat pengguna menekan tombol Tambah (+) di halaman utama, aplikasi menavigasi ke ProdukForm tanpa membawa parameter data.

Logika Deteksi Mode:
Di dalam initState(), fungsi isUpdate() dijalankan. Karena widget.produk bernilai null, form secara otomatis mengatur:

Judul: "TAMBAH PRODUK BARU"

Tombol: "SIMPAN PRODUK"

Controller: Dibiarkan kosong.

<details>
<summary><b>🔻 Lihat Kode Deteksi Mode (Klik Disini)</b></summary>

// lib/ui/produk_form.dart

isUpdate() {
  if (widget.produk != null) {
    // ... Logika Update ...
  } else {
    // Logika Tambah Data
    judul = "TAMBAH PRODUK BARU";
    tombolSubmit = "SIMPAN PRODUK";
  }
}


</details>
</td>
</tr>

<tr>
<td width="30%">
<!-- GANTI DENGAN LINK/PATH GAMBAR DIAGRAM/REQUEST -->
<img width="2048" height="2048" alt="Gemini_Generated_Image_sxubqxsxubqxsxub" src="https://github.com/user-attachments/assets/9e0db669-d0f9-4b40-90c1-1c1626ff3be2" />

</td>
<td width="70%">

b. Eksekusi Simpan & Request API

Saat tombol simpan ditekan, fungsi simpan() dipanggil.

Alur Data:

UI: Membuat objek Produk baru dari input text controller.

BLoC: Memanggil ProdukBloc.addProduk().

API: Mengirim request POST ke endpoint /produk dengan body JSON berisi kode_produk, nama_produk, dan harga.

<details>
<summary><b>🔻 Lihat Kode Simpan & BLoC</b></summary>

// lib/ui/produk_form.dart -> simpan()
void simpan() {
  Produk createProduk = Produk(id: null);
  createProduk.kodeProduk = _kodeProdukTextboxController.text;
  // ... isi properti lain
  
  ProdukBloc.addProduk(produk: createProduk).then((value) {
    // Navigasi jika sukses (lihat poin c)
  }, onError: (error) { ... });
}


// lib/bloc/produk_bloc.dart
static Future<bool> addProduk({Produk? produk}) async {
  String apiUrl = ApiUrl.createProduk;
  
  var body = {
    "kode_produk": produk!.kodeProduk,
    "nama_produk": produk.namaProduk,
    "harga": produk.hargaProduk.toString()
  };
  
  var response = await Api().post(apiUrl, body);
  var jsonObj = json.decode(response.body);
  return jsonObj['status']; // Mengembalikan true/false
}


</details>
</td>
</tr>

<tr>
<td width="30%">
<!-- GANTI DENGAN LINK/PATH GAMBAR LIST PRODUK SETELAH DITAMBAH -->
<img width="382" height="608" alt="isi-produk" src="https://github.com/user-attachments/assets/a2e57b24-8b61-4bc0-9baf-5e2ba0f39579" />

</td>
<td width="70%">

c. Feedback & Refresh Halaman

Setelah data berhasil disimpan ke server, aplikasi perlu memperbarui tampilan daftar produk di halaman utama.

Strategi Navigasi:
Kami menggunakan Navigator.pushReplacement.
Ini akan membuang halaman Form saat ini dan menggantinya dengan halaman ProdukPage baru. Efeknya, halaman utama akan dimuat ulang (reload) dan data baru akan muncul secara otomatis melalui FutureBuilder.

<details>
<summary><b>🔻 Lihat Kode Navigasi Refresh</b></summary>

// lib/ui/produk_form.dart

ProdukBloc.addProduk(produk: createProduk).then((value) {
    // Mengganti halaman form dengan halaman list baru
    // agar data ter-refresh otomatis
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => const ProdukPage())
    );
}, onError: (error) {
    showDialog(... WarningDialog ...);
});


</details>
</td>
</tr>
</table>

4. ✏️ Proses Ubah Produk (Update Data)

Fitur ini menggunakan kembali file UI ProdukForm. Perbedaannya terletak pada inisialisasi awal di mana form akan terisi otomatis dengan data produk yang akan diedit.

<table>
<tr>
<td width="30%">
<!-- GANTI DENGAN LINK/PATH GAMBAR SS FORM EDIT (TERISI) ANDA -->
<img width="382" height="822" alt="update-produk" src="https://github.com/user-attachments/assets/14459765-b66f-4f1e-a127-691b3ef53fe6" />
</td>
<td width="70%">

a. Inisialisasi Form (Mode Ubah)

Saat pengguna menekan tombol Ubah di halaman detail, navigasi dilakukan dengan membawa objek produk sebagai parameter.

Logika Deteksi Mode:
Fungsi isUpdate() mendeteksi keberadaan data widget.produk.

Judul: "UBAH PRODUK"

Tombol: "UBAH"

Controller: Diisi dengan data lama (kode, nama, harga).

<details>
<summary><b>🔻 Lihat Kode Pengisian Form Otomatis</b></summary>

// lib/ui/produk_form.dart

isUpdate() {
  if (widget.produk != null) {
    judul = "UBAH PRODUK";
    tombolSubmit = "UBAH";
    _kodeProdukTextboxController.text = widget.produk!.kodeProduk!;
    _namaProdukTextboxController.text = widget.produk!.namaProduk!;
    _hargaProdukTextboxController.text = widget.produk!.hargaProduk.toString();
  } else {
    // Mode Tambah...
  }
}


</details>
</td>
</tr>

<tr>
<td width="30%">
<!-- GANTI DENGAN LINK/PATH GAMBAR LOGIKA/DIAGRAM -->
<img width="2048" height="2048" alt="Gemini_Generated_Image_8wxhqu8wxhqu8wxh" src="https://github.com/user-attachments/assets/7899cccd-05fb-45e2-84c2-c9b5ac8225fb" />
</td>
<td width="70%">

b. Eksekusi Update & Request API

Saat tombol "UBAH" ditekan, fungsi ubah() dipanggil.

Alur Data:

UI: Mengambil ID dari produk lama dan data baru dari input.

BLoC: Memanggil ProdukBloc.updateProduk().

API: Mengirim request PUT ke endpoint /produk/{id}.

<details>
<summary><b>🔻 Lihat Kode Update BLoC</b></summary>

// lib/ui/produk_form.dart -> ubah()
void ubah() {
  // Menggunakan ID produk yang sedang diedit
  Produk updateProduk = Produk(id: widget.produk!.id!);
  updateProduk.kodeProduk = _kodeProdukTextboxController.text;
  // ...
  
  ProdukBloc.updateProduk(produk: updateProduk).then((value) {
     // Navigasi Refresh (lihat poin c pada Tambah Produk)
  }, onError: (error) { ... });
}


// lib/bloc/produk_bloc.dart
static Future<bool> updateProduk({required Produk produk}) async {
  // Membuat URL dinamis berdasarkan ID
  String apiUrl = ApiUrl.updateProduk(int.parse(produk.id!));
  
  var body = {
    "kode_produk": produk.kodeProduk,
    "nama_produk": produk.namaProduk,
    "harga": produk.hargaProduk.toString()
  };
  
  // Method PUT
  var response = await Api().put(apiUrl, body);
  return json.decode(response.body)['status'];
}


</details>
</td>
</tr>
</table>

<hr />

5. 🗑️ Proses Hapus Produk (Delete Data)

Fitur untuk menghapus data permanen dari database. Memerlukan konfirmasi pengguna untuk mencegah ketidaksengajaan.

<table>
<tr>
<td width="30%">
<!-- GANTI DENGAN LINK/PATH GAMBAR POPUP KONFIRMASI HAPUS ANDA -->
<img width="392" height="818" alt="hapus-produk-popup" src="https://github.com/user-attachments/assets/4ab5a7f6-a8a3-4392-bdc8-13434396959f" />

</td>
<td width="70%">

a. Konfirmasi Hapus (Dialog)

Di halaman ProdukDetail, menekan tombol Hapus tidak langsung menghapus data, melainkan memunculkan AlertDialog.

Logika UI:
Dialog memiliki dua opsi: "Batal" (menutup dialog) dan "Ya" (menjalankan eksekusi hapus).

<details>
<summary><b>🔻 Lihat Kode Dialog Konfirmasi</b></summary>

// lib/ui/produk_detail.dart

void confirmHapus() {
  AlertDialog alertDialog = AlertDialog(
    content: const Text("Yakin ingin menghapus data ini?"),
    actions: [
      TextButton(
        child: const Text("Batal"),
        onPressed: () => Navigator.pop(context),
      ),
      TextButton(
        child: const Text("Ya", style: TextStyle(color: Colors.red)),
        onPressed: () {
          // Panggil BLoC Delete (lihat poin b)
        },
      ),
    ],
  );
  showDialog(context: context, builder: (_) => alertDialog);
}


</details>
</td>
</tr>

<tr>
<td width="30%">
<!-- GANTI DENGAN LINK/PATH GAMBAR LIST PRODUK SETELAH DIHAPUS -->
<img width="2048" height="2048" alt="Gemini_Generated_Image_tpi6uftpi6uftpi6" src="https://github.com/user-attachments/assets/1dbf1498-6a3a-4229-9a43-3e0d7f6b9f52" />

</td>
<td width="70%">

b. Eksekusi Hapus & Navigasi

Jika pengguna memilih "Ya".

Alur Data:

BLoC: Memanggil ProdukBloc.deleteProduk(id).

API: Mengirim request DELETE ke endpoint /produk/{id}.

Navigasi: Menggunakan pushAndRemoveUntil untuk kembali ke halaman utama (ProdukPage) dan membersihkan riwayat navigasi (agar pengguna tidak bisa kembali ke halaman detail produk yang sudah dihapus).

<details>
<summary><b>🔻 Lihat Kode Delete & Navigasi</b></summary>

// lib/bloc/produk_bloc.dart
static Future<bool> deleteProduk({int? id}) async {
  String apiUrl = ApiUrl.deleteProduk(id!);
  var response = await Api().delete(apiUrl); // Method DELETE
  return json.decode(response.body)['status'];
}


// lib/ui/produk_detail.dart (onPressed Ya)
ProdukBloc.deleteProduk(id: int.parse(widget.produk!.id!)).then((value) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const ProdukPage()),
        (Route<dynamic> route) => false);
}, onError: (error) { ... });


</details>
</td>
</tr>
</table>



6. 📖 Proses Katalog Produk (Read Data)

Fitur ini adalah tampilan utama aplikasi setelah Login. Data diambil dari server dan ditampilkan dalam bentuk daftar kartu yang interaktif.

<table>
<tr>
<td width="30%">
<!-- GANTI DENGAN LINK/PATH GAMBAR SS LIST PRODUK ANDA -->
<img width="370" height="832" alt="list-produk" src="https://github.com/user-attachments/assets/41c03b36-e61b-486a-a923-fa16b1931942" />

</td>
<td width="70%">

a. Menampilkan Daftar (FutureBuilder)

Halaman ProdukPage menggunakan FutureBuilder untuk menangani status pengambilan data yang bersifat asynchronous.

Alur Data:

Inisialisasi: FutureBuilder memanggil ProdukBloc.getProduks().

Loading: Selama data belum diterima, CircularProgressIndicator ditampilkan.

Sukses: Jika data diterima, widget ListProduk dipanggil untuk merender ListView.

Error/Kosong: Menangani kondisi jika data kosong atau terjadi kesalahan koneksi.

<details>
<summary><b>🔻 Lihat Kode FutureBuilder</b></summary>

// lib/ui/produk_page.dart

body: FutureBuilder<List>(
  future: ProdukBloc.getProduks(),
  builder: (context, snapshot) {
    // 1. Status Loading
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    // 2. Status Error
    if (snapshot.hasError) {
      return Center(child: Text("Error: ${snapshot.error}"));
    }
    // 3. Status Sukses (Render List)
    return ListProduk(list: snapshot.data);
  },
)


</details>

Logika BLoC (GET):
Fungsi getProduks() melakukan request GET ke API dan mengonversi (parsing) array JSON menjadi List<Produk>.

<details>
<summary><b>🔻 Lihat Kode BLoC GET</b></summary>

// lib/bloc/produk_bloc.dart

static Future<List<Produk>> getProduks() async {
  String apiUrl = ApiUrl.listProduk;
  var response = await Api().get(apiUrl); // Request GET
  
  var jsonObj = json.decode(response.body);
  List<dynamic> listProduk = (jsonObj as Map<String, dynamic>)['data'];
  
  // Konversi JSON ke List Object
  List<Produk> produks = [];
  for (int i = 0; i < listProduk.length; i++) {
    produks.add(Produk.fromJson(listProduk[i]));
  }
  return produks;
}


</details>
</td>
</tr>

<tr>
<td width="30%">
<!-- GANTI DENGAN LINK/PATH GAMBAR SS DETAIL PRODUK ANDA -->
<img width="366" height="837" alt="detail-produk" src="https://github.com/user-attachments/assets/78b7f8cc-1861-43fc-b1cb-45451e6a3050" />

</td>
<td width="70%">

b. Detail Produk & Navigasi

Saat salah satu kartu produk diklik, pengguna diarahkan ke halaman ProdukDetail.

Logika Navigasi:
Objek Produk yang diklik dikirim sebagai parameter (argument) ke halaman detail. Ini menghindari perlunya melakukan request API ulang hanya untuk melihat data yang sudah ada di list.

Format Mata Uang:
Kami menggunakan pustaka intl untuk mengubah angka mentah (misal: 2000000) menjadi format Rupiah yang mudah dibaca (Rp2.000.000).

<details>
<summary><b>🔻 Lihat Kode Navigasi & Format</b></summary>

// lib/ui/produk_page.dart -> ItemProduk

onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProdukDetail(
        produk: produk, // Mengirim objek data
      )));
},


// lib/ui/produk_detail.dart

// Fungsi Helper Format Rupiah
String _formatCurrency(int price) {
  final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
  return format.format(price);
}


</details>
</td>
</tr>
</table>
