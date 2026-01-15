import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/member.dart';
import '../models/show_schedule.dart';

class ApiService {
  static const String baseUrl = "https://6961f708d9d64c7619069786.mockapi.io/users";

  // Register
  static Future<bool> register(User user) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );
    return response.statusCode == 201;
  }

  // Login
  static Future<User?> login(String email, String password) async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      for (var u in data) {
        if (u['email'] == email && u['password'] == password) {
          return User.fromJson(u);
        }
      }
    }
    return null;
  }

  // Cek email untuk forgot password
  static Future<User?> getUserByEmail(String email) async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      for (var u in data) {
        if (u['email'] == email) {
          return User.fromJson(u);
        }
      }
    }
    return null; 
  }

  // Update password
  static Future<bool> updatePassword(String idUser, String newPassword) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$idUser"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"password": newPassword}),
    );
    return response.statusCode == 200;
  }

  //get member
  static Future<List<Member>> getMembers() async {
    try {
      final response = await http.get(
        Uri.parse('https://6961f708d9d64c7619069786.mockapi.io/members'),
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.map((e) => Member.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print("Error getMembers: $e");
      return [];
    }
  }

  //get show
  static Future<List<ShowSchedule>> getShowSchedules() async {
    try {
      final response = await http.get(
        Uri.parse('https://6963742f2d146d9f58d383d2.mockapi.io/v2/show'),
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.map((e) => ShowSchedule.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print("Error getShowSchedules: $e");
      return [];
    }
  }

  // update profile
static Future<User?> updateUser(User user) async {
  final response = await http.put(
    Uri.parse("$baseUrl/${user.idUser}"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "nama": user.nama,
      "email": user.email,
      "password": user.password,
      "favMember": user.favMember, // idMember
    }),
  );

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  }
  return null;
}

// hapus akun
static Future<bool> deleteUser(String idUser) async {
  try {
    final response = await http.delete(
      Uri.parse("$baseUrl/$idUser"),
    );
    return response.statusCode == 200;
  } catch (e) {
    print("Error deleteUser: $e");
    return false;
  }
}

}
