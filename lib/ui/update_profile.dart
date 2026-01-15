import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/member.dart';
import '../services/api_service.dart';
import 'forgot_password.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({
    super.key,
    required this.user,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _namaController;
  late TextEditingController _emailController;

  List<Member> _members = [];
  String? _selectedMemberId;
  bool _loadingMember = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _namaController = TextEditingController(text: widget.user.nama);
    _emailController = TextEditingController(text: widget.user.email);
    _selectedMemberId = widget.user.favMember;

    _fetchMembers();
  }

  /// ambil nama depan buat greeting
  String getFirstName(String fullName) {
    if (fullName.trim().isEmpty) return '';
    return fullName.trim().split(' ').first;
  }

  Future<void> _fetchMembers() async {
    try {
      final data = await ApiService.getMembers();
      if (mounted) {
        setState(() {
          _members = data;
          _loadingMember = false;
        });
      }
    } catch (e) {
      setState(() {
        _loadingMember = false;
      });
    }
  }

  Future<void> _simpanData() async {
    setState(() => _saving = true);

    final updatedUser = User(
      idUser: widget.user.idUser,
      nama: _namaController.text,
      email: _emailController.text,
      password: widget.user.password,
      favMember: _selectedMemberId, 
    );

    final result = await ApiService.updateUser(updatedUser);

    if (!mounted) return;

    setState(() => _saving = false);

    if (result != null) {
      Navigator.pop(context, result);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menyimpan data"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    super.dispose();
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
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),

          // ===== BODY =====
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),

                  Text(
                    "Halo ${getFirstName(widget.user.nama)}!",
                    style: const TextStyle(fontSize: 24),
                  ),
                  const Text(
                    "Silakan lengkapi data berikut.",
                    style: TextStyle(fontSize: 20),
                  ),

                  const SizedBox(height: 40),

                  // ===== NAMA =====
                  TextField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      hintText: "Nama Lengkap",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ===== EMAIL =====
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: "Alamat Email",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // ===== OSHIMEN =====
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
                    child: _loadingMember
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.red,
                              ),
                            ),
                          )
                        : DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedMemberId,
                              isExpanded: true,
                              hint: const Text("Pilih Oshimen"),
                              items: _members.map((member) {
                                return DropdownMenuItem<String>(
                                  value: member.idMember,
                                  child: Text(
                                    member.fullName,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedMemberId = value;
                                });
                              },
                            ),
                          ),
                  ),

                  const SizedBox(height: 10),

                  // ===== GANTI PASSWORD =====
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
                      "Ganti password",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ===== SIMPAN =====
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD31010),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _saving ? null : _simpanData,
                      child: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Simpan",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
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
            color: const Color(0xFFD31010),
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: const [
                Text(
                  "Design By Erick Ade Hending Firmansyah - 12220003",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
                Text(
                  "MK Mobile Programming",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
