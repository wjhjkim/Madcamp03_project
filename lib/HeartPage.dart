import 'package:flutter/material.dart';
import 'menuDetailPage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Heartpage extends StatefulWidget {
  const Heartpage({super.key});

  @override
  _FavoriteMenuPage createState() => _FavoriteMenuPage();
}

class _FavoriteMenuPage extends State<Heartpage> {
  List<String> favoriteMenus = [
    // 'Spaghetti Carbonara',
    // 'Margherita Pizza',
    // 'Caesar Salad',
    // 'Grilled Salmon',
    // 'Chicken Alfredo',
    // 'Beef Tacos',
    // 'Sushi Platter',
    // 'Vegetable Stir Fry',
    // 'BBQ Ribs',
    // 'Mango Smoothie'
  ];

  String userID = "";

  Future<void> _loadUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID') ?? '';
  }

  Future<void> _initialize() async {
    await _loadUserID();
    _getFavoriteMenus(); // 여기에 실제 메뉴 이름을 입력하세요
  }

  void _getFavoriteMenus() async {
    final response = await http.post(
      Uri.parse('${dotenv.env['SERVER_URL']}/heart/get'),
      // 여기에 실제 서버 URL을 입력하세요
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userID': userID,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      setState(() {
        favoriteMenus = List<String>.from(jsonResponse["foodNames"]);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('좋아하는 메뉴를 불러오는 데 실패했습니다. 오류코드: ${response.statusCode} ${response.reasonPhrase}'),
        ),
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
      backgroundColor: Color(0xfff5f7fa),
      appBar: AppBar(
        title: Text(
          '하트를 누른 메뉴',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xfff5f7fa),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: favoriteMenus.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        menuDetailPage(menu_name: favoriteMenus[index]),
                  ),
                );
              },
              child: Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.favorite, color: Colors.red),
                  title: Text(
                    favoriteMenus[index],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
