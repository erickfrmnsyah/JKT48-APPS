import 'package:flutter/material.dart';
import 'mainpage.dart';
import 'forgot_password.dart';
import 'regist.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false; 

  void loginUser() async {
    setState(() {
      isLoading = true;
    });

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email dan password wajib diisi")));
      setState(() {
        isLoading = false;
      });
      return;
    }

    User? user = await ApiService.login(email, password);

    setState(() {
      isLoading = false;
    });

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login berhasil! Selamat datang ${user.nama}")));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainPage(user: user),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Login gagal! Email atau password salah")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // header
          Container(
            padding: const EdgeInsets.only(top: 50, left: 20, bottom: 15),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 50,
                ),
                const SizedBox(width: 12),
                const Text(
                  "JKT48\nAPPS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),

          // body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  const Text(
                    "Halo!",
                    style: TextStyle(fontSize: 24),
                  ),
                  const Text(
                    "Silakan masukkan email dan\npassword Anda untuk login.",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 40),

                  // Email
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: "Alamat Email",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFEE141F),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Password",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFEE141F),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Button Login
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEE141F),
                        elevation: 0,
                      ),
                      onPressed: isLoading ? null : loginUser,
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "LOGIN",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Lupa Password - Register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Lupa Password?",
                          style: TextStyle(color: Color(0xFFEE141F)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(color: Color(0xFFEE141F)),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),

          // footer
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
