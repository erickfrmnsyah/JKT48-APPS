import 'package:flutter/material.dart';
import '../models/member.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'detail_member.dart';
import 'schedule.dart';
import 'profile.dart';

class MainPage extends StatefulWidget {
  final User user;

  const MainPage({
    super.key,
    required this.user,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 1;

  List<Member> memberList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  void fetchMembers() async {
    try {
      final members = await ApiService.getMembers();
      setState(() {
        memberList = members;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  String getFirstName(String fullName) {
    if (fullName.trim().isEmpty) return '';
    return fullName.trim().split(' ').first;
  }

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

          // ===== CONTENT =====
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  Text(
                    "Selamat Datang, ${getFirstName(widget.user.nama)} 👋",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "JKT48 merupakan Idol Group dengan konsep \"idola yang dapat ditemui\" (Idol you can meet) yang merupakan sister group pertama AKB48 di luar Jepang sejak 2011.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),

                  // ===== TITLE =====
                  Container(
                    width: double.infinity,
                    color: const Color(0xFFD31010),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: const Center(
                      child: Text(
                        "Member JKT48",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ===== GRID MEMBER =====
                  isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(color: Colors.red),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 15,
                            childAspectRatio: 0.6,
                          ),
                          itemCount: memberList.length,
                          itemBuilder: (context, index) {
                            final member = memberList[index];

                            return InkWell(
                              borderRadius: BorderRadius.circular(6),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DetailMemberPage(
                                          member: member, 
                                          user: widget.user,),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(6),
                                        image: DecorationImage(
                                          image:
                                              NetworkImage(member.imageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFD31010),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(6),
                                        bottomRight: Radius.circular(6),
                                      ),
                                    ),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Text(
                                      member.fullName,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
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
        height: 70,
        color: const Color(0xFFD31010),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.newspaper, 0),
            _navItem(Icons.home, 1),
            _navItem(Icons.person, 2),
          ],
        ),
      ),
    );
  }

  // ===== NAV ITEM =====
  Widget _navItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        if (_selectedIndex == index) return;

        setState(() => _selectedIndex = index);

        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => SchedulePage(user: widget.user),
            ),
          );
        }

        if (index == 1) {
          // stay di home
          return;
        }

        if (index == 2) {
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
        color: _selectedIndex == index
            ? Colors.white
            : Colors.white70,
      ),
    );
  }
}
