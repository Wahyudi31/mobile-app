// api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:project_uas/models/user.dart';

class Auth {
  final String apiUrl = 'http://192.168.1.5:5000';

  Future<dynamic> Register(String name, String email, String password) async {
    Map data = {"name": name, "email": email, "password": password};
    try {
      http.Response hasil = await http.post(Uri.parse('$apiUrl/products'),
          headers: {"Accept": "application/json"}, body: json.encode(data));
      if (hasil.statusCode == 200) {
        return true;
      } else {
        // print("error status " + hasil.statusCode.toString());
        return false;
      }
    } catch (e) {
      // print("error catch $e");
      return false;
    }
  }

  Future<dynamic> Login(String name, String email, String password) async {
    Map data = {"name": name, "email": email, "password": password};
    try {
      http.Response hasil = await http.post(Uri.parse('$apiUrl/products'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Beare" + token,
          },
          body: json.encode(data));
      if (hasil.statusCode == 200) {
        return true;
      } else {
        // print("error status " + hasil.statusCode.toString());
        return false;
      }
    } catch (e) {
      // print("error catch $e");
      return false;
    }
  }
}
