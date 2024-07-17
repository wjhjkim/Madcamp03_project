import 'package:flutter/material.dart';
import 'package:madcamp03/SamplePage.dart';
import 'HeartPage.dart';
import 'AllergyPage.dart';
import 'ReviewPage.dart';

import 'package:shared_preferences/shared_preferences.dart';

class my_page extends StatefulWidget {
  const my_page({super.key});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<my_page> with TickerProviderStateMixin {
  String nickname = "UserNickname"; // 닉네임

  Future<void> _loadUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nickname = prefs.getString('userID') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f7fa),
      appBar: AppBar(
        title: Text('My Page', style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xfff5f7fa),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "환영합니다, " + nickname,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            _buildMenuButton(
              icon: Icons.favorite,
              label: '하트를 누른 메뉴',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Heartpage(),
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            _buildMenuButton(
              icon: Icons.warning,
              label: '알레르기 관리',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllergyPage(),
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            _buildMenuButton(
              icon: Icons.reviews,
              label: '쓴 리뷰 확인',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => reviewlistpage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
      {required IconData icon,
        required String label,
        required void Function() onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        minimumSize: Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
    );
  }
}