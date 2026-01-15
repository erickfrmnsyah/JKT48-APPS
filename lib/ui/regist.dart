import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/member.dart';
import '../services/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  List<Member> memberList = [];
  Member? selectedMember;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  // get list member
  void fetchMembers() async {
    List<Member> members = await ApiService.getMembers();
    setState(() {
      memberList = members;
    });
  }

  // register
  void register() async {
    String nama = namaController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (nama.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        selectedMember == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Semua field wajib diisi")));
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password tidak cocok")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Buat User baru
    User newUser = User(
      nama: nama,
      email: email,
      password: password,
      favMember: selectedMember!.idMember, 
    );

    bool success = await ApiService.register(newUser);

    setState(() {
      isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registrasi berhasil!")));
      Navigator.pop(context); // balik ke login
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal registrasi, coba lagi")));
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
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16, height: 1.1),
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
                  const SizedBox(height: 40),
                  const Text("Halo!", style: TextStyle(fontSize: 24)),
                  const Text("Silakan lengkapi data berikut.",
                      style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 30),

                  // NAMA
                  TextField(
                    controller: namaController,
                    decoration: const InputDecoration(
                      hintText: "Nama Lengkap",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFEE141F), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // EMAIL
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
                  const SizedBox(height: 15),

                  // PASSWORD
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Password",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFEE141F), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // KONFIRMASI PASSWORD
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Konfirmasi Password",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFEE141F), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // OSHIMEN (Dropdown)
                  const Text(
                    "Member yang disukai (Oshimen)",
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Member>(
                        value: selectedMember,
                        isExpanded: true,
                        hint: const Text("Pilih Member"),
                        items: memberList.map((Member m) {
                          return DropdownMenuItem<Member>(
                            value: m,
                            child: Text(m.fullName),
                          );
                        }).toList(),
                        onChanged: (Member? m) {
                          setState(() {
                            selectedMember = m;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // BUTTON DAFTAR
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEE141F),
                        elevation: 0,
                      ),
                      onPressed: isLoading ? null : register,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "DAFTAR",
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // KEMBALI KE LOGIN
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Sudah punya akun?",
                      style: TextStyle(color: Color(0xFFEE141F), fontSize: 14),
                    ),
                  ),

                  const SizedBox(height: 40),
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
