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
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 200.0,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.asset(
              menu[1],
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverPersistentHeader(
          delegate: _SliverAppBarDelegate(
            child: Container(
              color: Colors.white,
              child: Card(
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
                                  time + ', ' + menu[0] + ": " + '${menu[2]}원',
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
                              Text('${menu[3]}')
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
                            menuDetailPage(menu_name: menu[index + 4]),
                      ),
                    );
                  },
                  child: FavoriteCard(menu: menu.sublist(4), index: index));
            },
            childCount: menu.sublist(4).length,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '알레르기 표기 정보: 1.난류 2.우유 3.메밀 4.땅콩 5.대두 6.밀 7.고등어 8.게 9.새우 10.돼지고기 11.복숭아 12.토마토 13.아황산류 14.호두 15.닭고기 16.쇠고기 17.오징어 18.조개류 (굴, 전복, 홍합 포함)19.잣',
              style: TextStyle(fontSize: 10),
            ),
          ),
        ),
      ],
    );
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
  int star = 0;
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
      star = jsonResponse["starRating"];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('메뉴 하트를 불러오는 데 실패했습니다. 오류코드: ${response.statusCode}')),
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
    menu = widget.menu;
    index = widget.index;
    // _loadUserID();
    // _getFavoriteMenus(menu[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      title: Text(
        menu[index],
        style: TextStyle(fontSize: 18),
      ),
      subtitle: Text(
        "알레르기 정보: " + allergy.join(", "),
        style: TextStyle(fontSize: 14),
      ),
      trailing: SizedBox(
        width: 100, // 적절한 크기를 설정합니다.
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
                  isFavorite = !isFavorite;
                  // _changeFavoriteMenus(menu[index]);
                });
              },
            ),
            Icon(Icons.star, color: Colors.amber),
            Text(" " + star.toString())
          ],
        ),
      ),
    ));
  }
}
