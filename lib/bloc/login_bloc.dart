import 'dart:convert';
import 'package:tokokita/helpers/api.dart'; // Import modul HTTP request
import 'package:tokokita/helpers/api_url.dart'; // Import daftar endpoint API
import 'package:tokokita/model/login.dart'; // Import model data Login

class LoginBloc {
  static Future<Login> login({String? email, String? password}) async {
    // Menentukan URL endpoint login
    String apiUrl = ApiUrl.login; // [cite: 272]
    
    // Mempersiapkan body request (data yang dikirim)
    var body = {"email": email, "password": password}; // [cite: 273]
    
    // Mengirim permintaan POST ke API
    var response = await Api().post(apiUrl, body); // [cite: 274]
    
    // Mendekode (decode) respons JSON dari API
    var jsonObj = json.decode(response.body); // [cite: 275]
    
    // Mengembalikan objek Login dari data JSON
    return Login.fromJson(jsonObj); // [cite: 276]
  }
}