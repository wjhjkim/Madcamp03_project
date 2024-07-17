import 'package:flutter/material.dart';
import 'menuDetailPage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:shared_preferences/shared_preferences.dart';

class reviewlistpage extends StatefulWidget {
  const reviewlistpage({super.key});

  @override
  ReviewListPage createState() => ReviewListPage();
}

class ReviewListPage extends State<reviewlistpage> {
  List<List<String>> reviews = [
    ['정말 맛있어요!', "menu", "String", "5.0"],
    ['괜찮아요.', "menu", "String", "3.0"],
    ['별로였어요.', "menu", "String", "1.0"],
  ];

  String userID = "";

  Future<void> _loadUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID') ?? '';
  }

  Future<void> _initialize() async {
    await _loadUserID();
    _getUserReview();  // 여기에 실제 메뉴 이름을 입력하세요
  }

  void _getUserReview() async {
    final response = await http.post(
      Uri.parse('${dotenv.env['SERVER_URL']}/review/get/user'),
      // 여기에 실제 서버 URL을 입력하세요
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userID': userID,
      }),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      setState(() {
        reviews = [];
        for (var i in jsonResponse) {
          List<String> a = [];
          a.add(i["content"]);
          a.add(i["foodName"]);
          String b = i["reviewDate"];
          // DateTime b1 = i["reviewDate"];
          a.add(b);
          // a.add(DateFormat('yyyy년 MM월 dd일').format(b1));
          a.add(i["starRating"].toString());
          reviews.add(a);
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('리뷰를 불러오는 것을 실패했습니다. 오류코드: ${response.statusCode}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 리뷰'),
      ),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        menuDetailPage(menu_name: reviews[index][1]),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 30,
                      child: Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber),
                          Text(' ${reviews[index][3]}')
                        ],
                      ),
                    ),
                    title: Text(reviews[index][0]),
                    subtitle: Text(reviews[index][1])),
              ));
        },
      ),
    );
  }
}
