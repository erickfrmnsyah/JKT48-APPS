import 'package:flutter/material.dart';
import '../models/show_schedule.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'mainpage.dart';
import 'profile.dart';

class SchedulePage extends StatefulWidget {
  final User user;

  const SchedulePage({
    super.key,
    required this.user,
  });

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late Future<List<ShowSchedule>> _futureSchedules;
  int _selectedIndex = 0; // default ke Schedule page = 0

  @override
  void initState() {
    super.initState();
    _futureSchedules = ApiService.getShowSchedules();
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

          // ===== BODY =====
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  // title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: const [
                        Text(
                          "Theater JKT48",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Lebih dekat di Theater JKT48 FX Sudirman. Hadir dengan show rutin hampir setiap hari, memberi ruang interaksi bagi penggemar untuk tumbuh dan berkembang bersama para fans.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    color: const Color(0xFFEE141F),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: const Center(
                      child: Text(
                        "Jadwal Show",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // table
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        _tableHeader(),
                        FutureBuilder<List<ShowSchedule>>(
                          future: _futureSchedules,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.all(30),
                                child: CircularProgressIndicator(
                                  color: Color(0xFFEE141F),
                                ),
                              );
                            }

                            if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(20),
                                child: Text("Tidak ada jadwal show"),
                              );
                            }

                            return Column(
                              children: snapshot.data!
                                  .map((e) => _tableRow(e))
                                  .toList(),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "*Line up dapat berubah sewaktu-waktu tanpa pemberitahuan terlebih dahulu",
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
      // ===== BOTTOM NAV =====
      bottomNavigationBar: Container(
        color: const Color(0xFFD31010),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.newspaper, 0),
            _buildNavItem(Icons.home, 1),
            _buildNavItem(Icons.person, 2),
          ],
        ),
      ),
    );
  }

  // ===== NAV ITEM =====
  Widget _buildNavItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        if (_selectedIndex == index) return;

        setState(() => _selectedIndex = index);

        if (index == 0) {
          // Schedule page, stay disini
          return;
        }

        if (index == 1) {
          // Home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => MainPage(user: widget.user),
            ),
          );
        }

        if (index == 2) {
          // Profile
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ProfilePage(user: widget.user),
            ),
          );
        }
      },
      child: Icon(
        icon,
        size: 40,
        color: _selectedIndex == index ? Colors.white : Colors.white70,
      ),
    );
  }

  // ===== TABLE HEADER =====
  Widget _tableHeader() {
    return Container(
      color: const Color(0xFFF6CFCF),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: const [
          _HeaderCell(text: "Jadwal", flex: 2),
          _HeaderCell(text: "Setlist", flex: 2),
          _HeaderCell(text: "Line Up", flex: 3),
        ],
      ),
    );
  }

  // ===== TABLE ROW =====
  Widget _tableRow(ShowSchedule data) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black12),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          _BodyCell(text: "${data.tglShow}\n${data.jamShow}", flex: 2),
          _BodyCell(text: data.setlist, flex: 2),
          _BodyCell(text: data.lineUp, flex: 3),
        ],
      ),
    );
  }
}

// ===== COMPONENT =====
class _HeaderCell extends StatelessWidget {
  final String text;
  final int flex;

  const _HeaderCell({required this.text, required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _BodyCell extends StatelessWidget {
  final String text;
  final int flex;

  const _BodyCell({required this.text, required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Text(
          text,
          style: const TextStyle(fontSize: 11),
        ),
      ),
    );
  }
}
