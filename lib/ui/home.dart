import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              border: Border(
                bottom: BorderSide(color: Colors.black12, width: 1),
              ),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 45,
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
            child: Center(
              child: Text(
                "Halo 👋\nSelamat Datang di JKT48 Apps",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
