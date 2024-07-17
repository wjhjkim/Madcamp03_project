import 'package:flutter/material.dart';
import 'menuDetailPage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class show_cafeteria_menu extends StatefulWidget {
  const show_cafeteria_menu(
      {super.key, required this.date, required this.time, required this.menu});

  final List<String> menu;
  final DateTime date;
  final String time;

  @override
  _show_menu createState() => _show_menu();
}

class _show_menu extends State<show_cafeteria_menu>
    with TickerProviderStateMixin {
  DateTime date = DateTime.now();
  List<String> menu = [];
  String time = "";
  String new_date = "";
  List<bool> isSelected = [true, false, false];

  @override
  void initState() {
    super.initState();
    menu = widget.menu;
    date = widget.date;
    new_date = DateFormat('yyyy년 MM월 dd일').format(date);
    time = widget.time;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyCustomScrollView(
        date: new_date,
        time: time,
        menu: menu,
      ),
    );
  }
}

class MyCustomScrollView extends StatefulWidget {
  const MyCustomScrollView(
      {super.key, required this.date, required this.time, required this.menu});

  final List<String> menu;
  final String date;
  final String time;

  @override
  _MyCustomScrollView createState() => _MyCustomScrollView();
}

class _MyCustomScrollView extends State<MyCustomScrollView> {
  String date = "";
  List<String> menu = [];
  String time = "";
  String time_stamp = "";

  @override
  void initState() {
    super.initState();
    menu = widget.menu;
    date = widget.date;
    time = widget.time;
    if (time == "아침")
      time_stamp = "08:00 ~ 09:00";
    else if (time == "점심")
      time_stamp = "11:30 ~ 13:30";
    else
      time_stamp = "17:30 ~ 19:00";
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: 'menucard',
        child: Scaffold(
      backgroundColor: Color(0xfff5f7fa),
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Color(0xfff5f7fa),
          pinned: true,
          expandedHeight: 200.0,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.network(
              menu[1],
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverPersistentHeader(
          delegate: _SliverAppBarDelegate(
            child: Container(
              color: Color(0xfff5f7fa),
              child: Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  time + ', ' + menu[0],
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(date + ' ' + time_stamp)
                              ]),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber),
                              Text('${menu[2]}')
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            minHeight: 100.0,
            maxHeight: 100.0,
          ),
          pinned: true,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            menuDetailPage(menu_name: menu[index + 3]),
                      ),
                    );
                  },
                  child: FavoriteCard(menu: menu.sublist(3), index: index));
            },
            childCount: menu.sublist(3).length,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '알레르기 표기 정보: 1.난류 2.우유 3.메밀 4.땅콩 5.대두 6.밀 7.고등어 8.게 9.새우 10.돼지고기 11.복숭아 12.토마토 13.아황산류 14.호두 15.닭고기 16.쇠고기 17.오징어 18.조개류 (굴, 전복, 홍합 포함) 19.잣',
              style: TextStyle(fontSize: 10),
            ),
          ),
        ),
      ],
    )));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxExtent ||
        minHeight != oldDelegate.minExtent; // ||
    // child != oldDelegate.child;
  }
}

class FavoriteCard extends StatefulWidget {
  const FavoriteCard({super.key, required this.menu, required this.index});

  final List<String> menu;
  final int index;

  @override
  _FavoriteCardState createState() => _FavoriteCardState();
}

class _FavoriteCardState extends State<FavoriteCard> {
  bool isFavorite = false;
  List<String> menu = [];
  int index = 0;
  double star = 0.0;
  String userID = "";
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

  Future<void> _initialize(String menu_Name) async {
    await _loadUserID();
    _getFoodInfo(menu_Name); // 여기에 실제 메뉴 이름을 입력하세요
  }

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

  Future<void> _loadUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getString('userID') ?? '';
    });
  }

  void _getFoodInfo(String menu_name) async {
    print(menu_name + " " + userID);
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
        star = jsonResponse["starRating"].toDouble();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
            Text('메뉴 하트를 불러오는 데 실패했습니다. 오류코드: ${response.statusCode} ${response.reasonPhrase}')),
      );
      print("오류발생: ${response.statusCode} ${response.reasonPhrase}");
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
            Text('메뉴 하트를 변경하는 데 실패했습니다. 오류코드: ${response.statusCode} ${response.reasonPhrase}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    menu = widget.menu;
    index = widget.index;
    _initialize(menu[index]);
    _loadAllergies();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: ListTile(
        title: Text(
          menu[index],
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: RichText(
          text: TextSpan(
            text: '알레르기: ',
            style: TextStyle(color: Colors.black),
            children: [
              ...allergy.map((item) {
                if (_allergies[_allergies_map[item-1]] == true) {
                  return TextSpan(
                    text: '${_allergies_map[item-1]} ',
                    style: TextStyle(color: Colors.red),
                  );
                } else {
                  return TextSpan(
                    text: '${_allergies_map[item-1]} ',
                    style: TextStyle(color: Colors.black),
                  );
                }
              }).toList(),
            ],
          ),
        ),
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _changeFavoriteMenus(menu[index]);
                  });
                },
              ),
              Icon(Icons.star, color: Colors.amber),
              Text(
                " $star",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
