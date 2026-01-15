import 'package:flutter/material.dart';
import '../models/member.dart';
import '../models/user.dart';
import 'mainpage.dart';
import 'schedule.dart';
import 'profile.dart';

class DetailMemberPage extends StatelessWidget {
  final Member member;
  final User user;

  const DetailMemberPage({
    super.key,
    required this.member,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ===== BODY =====
      body: Column(
        children: [
          // ===== HEADER =====
          Container(
            padding: const EdgeInsets.only(top: 50, left: 10, bottom: 15),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                Image.asset('assets/images/logo.png', height: 40),
                const SizedBox(width: 12),
                const Text(
                  "JKT48\nAPPS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),

          // ===== CONTENT =====
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // ===== TITLE =====
                  Container(
                    width: double.infinity,
                    color: const Color(0xFFD31010),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text(
                      "Member JKT48",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ===== FOTO MEMBER =====
                  Container(
                    height: 260,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      image: DecorationImage(
                        image: NetworkImage(member.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  _buildDetailRow("Nama Lengkap", member.fullName),
                  _buildDetailRow("Nama Panggilan", member.nickName),
                  _buildDetailRow("Tanggal Lahir", member.birthDate),
                  _buildDetailRow(
                    "Tinggi Badan (cm)",
                    member.tinggiBadan.toString(),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // ===== BOTTOM NAV =====
          Container(
            height: 70,
            color: const Color(0xFFD31010),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SchedulePage(user: user),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.newspaper,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MainPage(user: user),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfilePage(user: user),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== ROW DETAIL =====
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 16)),
              Text(
                value,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
          const Divider(thickness: 1),
        ],
      ),
    );
  }
}
