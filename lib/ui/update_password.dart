import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class UpdatePasswordPage extends StatefulWidget {
  final User user; // <-- parameter dari forgot_password.dart

  const UpdatePasswordPage({super.key, required this.user});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;

  void updatePassword() async {
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Semua field wajib diisi")));
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Password tidak cocok")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    bool success =
        await ApiService.updatePassword(widget.user.idUser!, password);

    setState(() {
      isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Password berhasil diubah")));
      Navigator.popUntil(context, (route) => route.isFirst); // kembali ke login
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Gagal mengubah password")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ===== HEADER =====
          Container(
            padding: const EdgeInsets.only(top: 50, left: 20, bottom: 15),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              children: [
                Image.asset('assets/images/logo.png', height: 50),
                const SizedBox(width: 12),
                const Text(
                  "JKT48\nAPPS",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16, height: 1.1),
                ),
              ],
            ),
          ),

          // ===== BODY =====
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 120),
                  const Text(
                    "Silakan atur\npassword baru Anda",
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w400, height: 1.2),
                  ),
                  const SizedBox(height: 40),

                  // Password Baru
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Password Baru",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFEE141F), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Konfirmasi Password
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Konfirmasi Password",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFEE141F), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Button Ubah Password
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEE141F),
                        elevation: 0,
                      ),
                      onPressed: isLoading ? null : updatePassword,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "UBAH PASSWORD",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ===== FOOTER =====
          Container(
            width: double.infinity,
            color: const Color(0xFFEE141F),
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: const Column(
              children: [
                Text(
                  "Design By Erick Ade Hending Firmansyah - 12220003",
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
                Text(
                  "MK Mobile Programming",
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
