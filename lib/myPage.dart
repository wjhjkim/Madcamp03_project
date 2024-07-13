import 'package:flutter/material.dart';
import 'package:madcamp03/SamplePage.dart';
import 'HeartPage.dart';
import 'AllergyPage.dart';
import 'ReviewPage.dart';

class my_page extends StatefulWidget {
  const my_page({super.key});

  @override
  _my_page createState() => _my_page();
}

class _my_page extends State<my_page>
    with TickerProviderStateMixin {
  final String nickname = "UserNickname"; // 닉네임

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Page'),
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
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Heartpage(),
                  ),
                );
              },
              icon: Icon(Icons.favorite),
              label: Text('하트를 누른 메뉴'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48), // 버튼을 가로로 꽉 채우기
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllergyPage(),
                  ),
                );
              },
              icon: Icon(Icons.warning),
              label: Text('알레르기 관리'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => reviewlistpage(),
                  ),
                );
              },
              icon: Icon(Icons.reviews),
              label: Text('쓴 리뷰 확인'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}