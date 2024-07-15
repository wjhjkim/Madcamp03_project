import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:shared_preferences/shared_preferences.dart';

class menuDetailPage extends StatefulWidget {
  const menuDetailPage({super.key, required this.menu_name});

  final String menu_name;

  @override
  _MenuDetailPage createState() => _MenuDetailPage();
}

class _MenuDetailPage extends State<menuDetailPage> {
  String menuImageUrl = 'https://via.placeholder.com/400';
  String menuName = 'Spaghetti Carbonara';
  double menuRating = 4.5;
  bool isFavorite = false;
  List<List<String>> reviews = [
    ['정말 맛있어요!', "user", "String", "5.0"],
    ['괜찮아요.', "user", "String", "3.0"],
    ['별로였어요.', "user", "String", "1.0"],
  ];
  String userID = "";
  List<int> allergy = [];

  Future<void> _loadUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID') ?? '';
  }

  void _getFoodInfo(String menu_name) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['SERVER_URL']}/food'),
      // 여기에 실제 서버 URL을 입력하세요
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'foodName': menu_name,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      isFavorite = jsonResponse["heart"];
      allergy = jsonResponse["allergy"];
      menuRating = jsonResponse["starRating"];
      menuImageUrl = jsonResponse["imageURL"];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('메뉴 하트를 불러오는 데 실패했습니다. 오류코드: ${response.statusCode}')),
      );
    }
  }

  void _getFoodReview() async {
    final response = await http.post(
      Uri.parse('${dotenv.env['SERVER_URL']}/review/get/food'),
      // 여기에 실제 서버 URL을 입력하세요
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'foodName': menuName,
      }),
    );

    if (response.statusCode == 200) {
      List<List<String>> jsonResponse = json.decode(response.body);
      reviews = jsonResponse;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('리뷰를 불러오는 것을 실패했습니다. 오류코드: ${response.statusCode}')),
      );
    }
  }

  void _changeFavoriteMenus(String menu_name) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['SERVER_URL']}/food/change/heart'),
      // 여기에 실제 서버 URL을 입력하세요
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userID': userID,
        'foodName': menu_name,
      }),
    );

    if (response.statusCode == 200) {
      isFavorite = !isFavorite;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('메뉴 하트를 불러오는 데 실패했습니다. 오류코드: ${response.statusCode}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    menuName = widget.menu_name;
    // _loadUserID();
    // _getFavoriteMenus(menu[index]);
    // _getFoodReview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(menuName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              menuImageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menuName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: menuRating,
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 20.0,
                              direction: Axis.horizontal,
                            ),
                            SizedBox(width: 8),
                            Text(menuRating.toString(),
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              isFavorite = !isFavorite;
                              _changeFavoriteMenus(menuName);
                            });
                          },
                        )
                      ]),
                  SizedBox(height: 16),
                  Text(
                    "알레르기 정보: " + allergy.join(", "),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '리뷰',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ...reviews.map((review) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(review[0]),
                        subtitle: Row(
                          children: [
                            RatingBarIndicator(
                              rating: double.parse(review[3]),
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 20.0,
                              direction: Axis.horizontal,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(review[1]),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
