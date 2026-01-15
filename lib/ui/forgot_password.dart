import 'package:flutter/material.dart';
import 'update_password.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  bool isLoading = false;

  void checkEmail() async {
    String email = emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email wajib diisi")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    User? user = await ApiService.getUserByEmail(email);

    setState(() {
      isLoading = false;
    });

    if (user != null) {
      // Navigate ke UpdatePasswordPage dan kirim data user
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UpdatePasswordPage(user: user),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Email tidak ditemukan")));
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, height: 1.1),
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
                    "Silakan masukkan\nEmail Anda",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, height: 1.2),
                  ),
                  const SizedBox(height: 40),

                  // Input Email
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: "Alamat Email",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFEE141F), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),

                  // Button Lanjut
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEE141F),
                        elevation: 0,
                      ),
                      onPressed: isLoading ? null : checkEmail,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "LANJUT",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Back to Login
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      "Login Sekarang",
                      style: TextStyle(color: Color(0xFFEE141F), fontSize: 14),
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
