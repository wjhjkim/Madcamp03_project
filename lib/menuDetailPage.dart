import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class menuDetailPage extends StatefulWidget {
  const menuDetailPage({super.key, required this.menu_name});

  final String menu_name;

  @override
  _MenuDetailPage createState() => _MenuDetailPage();
}

class _MenuDetailPage extends State<menuDetailPage> {
  String menuImageUrl = 'https://via.placeholder.com/400';
  String menuName = 'Spaghetti Carbonara';
  double menuRating = 0.0;
  bool isFavorite = false;
  List<List<String>> reviews = [];
  String userID = "sample";
  List<int> allergy = [];

  Map<int, String> _allergies_map = {
    0: "난류",
    1: "우유",
    2: "메밀",
    3: "땅콩",
    4: "대두",
    5: "밀",
    6: "고등어",
    7: "게",
    8: "새우",
    9: "돼지고기",
    10: "복숭아",
    11: "토마토",
    12: "아황산류",
    13: "호두",
    14: "닭고기",
    15: "쇠고기",
    16: "오징어",
    17: "조개류",
    18: "잣",
  };

  Map<String, bool> _allergies = {
    "난류": false,
    "우유": false,
    "메밀": false,
    "땅콩": false,
    "대두": false,
    "밀": false,
    "고등어": false,
    "게": false,
    "새우": false,
    "돼지고기": false,
    "복숭아": false,
    "토마토": false,
    "아황산류": false,
    "호두": false,
    "닭고기": false,
    "쇠고기": false,
    "오징어": false,
    "조개류": false,
    "잣": false,
  };

  Future<void> _loadAllergies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? allergiesJson = prefs.getString('allergies');
    if (allergiesJson != null) {
      final Map<String, bool> loadedAllergies =
      Map<String, bool>.from(json.decode(allergiesJson));
      Future.delayed(Duration.zero, () {
        setState(() {
          _allergies = loadedAllergies;
        });
      });
    }
  }

  Future<void> _initialize(String menu_Name) async {
    await _loadUserID();
    _getFoodInfo(menu_Name);
    _getFoodReview(menu_Name);
  }

  Future<void> _loadUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getString('userID') ?? '';
    });
  }

  void _getFoodInfo(String menu_name) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['SERVER_URL']}/food'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'foodName': menu_name,
        'userID': userID,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      setState(() {
        isFavorite = jsonResponse["heart"];
        if (jsonResponse["allergy"] != []) {
          List<int> intList = jsonResponse["allergy"]
              .map((item) {
            try {
              return int.parse(item.toString());
            } catch (e) {
              print('Could not convert $item to int');
              return null;
            }
          })
              .where((item) => item != null)
              .cast<int>()
              .toList();
          allergy = intList;
        }
        menuRating = jsonResponse["starRating"].toDouble();
        menuImageUrl =
            jsonResponse["image"] ?? "https://via.placeholder.com/400";
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
            Text('메뉴 하트를 불러오는 데 실패했습니다. 오류코드: ${response.statusCode}')),
      );
    }
  }

  void _getFoodReview(String menu_Name) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['SERVER_URL']}/review/get/food?foodName=$menu_Name'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      setState(() {
        reviews = [];
        for (var i in jsonResponse) {
          List<String> a = [];
          a.add(i["content"]);
          a.add(i["userID"]);
          String b = i["reviewDate"];
          a.add(b);
          a.add(i["starRating"].toString());
          reviews.add(a);
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
            Text('리뷰를 불러오는 것을 실패했습니다. 오류코드: ${response.statusCode}')),
      );
    }
  }

  void _changeFavoriteMenus(String menu_name) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['SERVER_URL']}/food/change/heart'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userID': userID,
        'foodName': menu_name,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        isFavorite = !isFavorite;
      });
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
    _initialize(menuName);
    _loadAllergies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f7fa),
      appBar: AppBar(
        // title: Text(menuName),
        backgroundColor: Color(0xfff5f7fa),
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        elevation: 0,
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
                            _changeFavoriteMenus(menuName);
                          },
                        )
                      ]),
                  SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      text: '알레르기: ',
                      style: TextStyle(color: Colors.black),
                      children: [
                        ...allergy.map((item) {
                          if (_allergies[_allergies_map[item]] == true) {
                            return TextSpan(
                              text: '${_allergies_map[item]} ',
                              style: TextStyle(color: Colors.red),
                            );
                          } else {
                            return TextSpan(
                              text: '${_allergies_map[item]} ',
                              style: TextStyle(color: Colors.black),
                            );
                          }
                        }).toList(),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '리뷰',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ...reviews.map((review) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          review[0],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
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
                            SizedBox(width: 20),
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
