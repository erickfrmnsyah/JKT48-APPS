import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/member.dart';
import '../services/api_service.dart';
import 'mainpage.dart';
import 'schedule.dart';
import 'login.dart';
import 'update_profile.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({
    super.key,
    required this.user,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 2;
  Member? favMemberData;
  bool isLoading = true;

  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    fetchFavMember();
  }

  /// Ambil data member berdasarkan ID oshimen
  void fetchFavMember() async {
    try {
      setState(() => isLoading = true);

      final members = await ApiService.getMembers();
      Member? result;

      if (_currentUser.favMember != null &&
          _currentUser.favMember!.isNotEmpty) {
        for (var m in members) {
          if (m.idMember == _currentUser.favMember) {
            result = m;
            break;
          }
        }
      }

      if (mounted) {
        setState(() {
          favMemberData = result;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // ================== HAPUS AKUN ==================
  Future<void> _confirmDeleteAccount() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Hapus Akun"),
          content: const Text(
            "Apakah kamu yakin ingin menghapus akun ini?\n"
            "Data yang dihapus tidak dapat dikembalikan.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      _deleteAccount();
    }
  }

  Future<void> _deleteAccount() async {
    if (_currentUser.idUser == null) return;

    final success =
        await ApiService.deleteUser(_currentUser.idUser!);

    if (!mounted) return;

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menghapus akun"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  // =================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ===== BODY =====
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

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ===== TITLE =====
                  Container(
                    width: double.infinity,
                    color: const Color(0xFFD31010),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: const Center(
                      child: Text(
                        "My Page",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ===== FOTO OSHIMEN =====
                  isLoading
                      ? const CircularProgressIndicator(color: Colors.red)
                      : Container(
                          height: 180,
                          width: 140,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            image: favMemberData != null
                                ? DecorationImage(
                                    image: NetworkImage(
                                      favMemberData!.imageUrl,
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: favMemberData == null
                              ? const Icon(
                                  Icons.person,
                                  size: 80,
                                  color: Colors.white,
                                )
                              : null,
                        ),

                  const SizedBox(height: 40),

                  // ===== DATA USER =====
                  _profileRow("ID", _currentUser.idUser ?? "-"),
                  _profileRow("Nama Lengkap", _currentUser.nama),
                  _profileRow("Email", _currentUser.email),
                  _profileRow(
                    "Oshimen",
                    favMemberData?.fullName ?? "-",
                  ),

                  const SizedBox(height: 30),

                  // ===== BUTTON =====
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFFD31010),
                              width: 2,
                            ),
                            minimumSize:
                                const Size(double.infinity, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            final updatedUser =
                                await Navigator.push<User>(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    EditProfilePage(user: _currentUser),
                              ),
                            );

                            if (updatedUser != null) {
                              setState(() {
                                _currentUser = updatedUser;
                              });
                              fetchFavMember();
                            }
                          },
                          child: const Text(
                            "PERBARUI DATA",
                            style: TextStyle(
                              color: Color(0xFFD31010),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // ===== HAPUS AKUN =====
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFFD31010),
                              width: 2,
                            ),
                            minimumSize:
                                const Size(double.infinity, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _confirmDeleteAccount,
                          child: const Text(
                            "HAPUS AKUN",
                            style: TextStyle(
                              color: Color(0xFFD31010),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFD31010),
                            minimumSize:
                                const Size(double.infinity, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                              (route) => false,
                            );
                          },
                          child: const Text(
                            "LOGOUT",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),

      // ===== BOTTOM NAV =====
      bottomNavigationBar: Container(
        height: 70,
        color: const Color(0xFFD31010),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.newspaper, 0, () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => SchedulePage(user: _currentUser),
                ),
              );
            }),
            _navItem(Icons.home, 1, () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => MainPage(user: _currentUser),
                ),
              );
            }),
            _navItem(Icons.person, 2, () {}),
          ],
        ),
      ),
    );
  }

  // ===== ROW PROFILE =====
  Widget _profileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.black87, thickness: 1),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, int index, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        size: 40,
        color:
            _selectedIndex == index ? Colors.white : Colors.white70,
      ),
    );
  }
}
