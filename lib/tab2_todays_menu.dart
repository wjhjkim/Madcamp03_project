import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'ChangeTextScreen.dart';
import 'ShowCafeteriaMenu.dart';
import 'SamplePage.dart';
import 'myPage.dart';
import 'MonthlyCalendar.dart';
import 'WriteReview.dart';
import 'menuShowOnepage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:shared_preferences/shared_preferences.dart';

class tab2_todays_menu extends StatefulWidget {
  const tab2_todays_menu({super.key});

  @override
  _todays_menuState createState() => _todays_menuState();
}

class _todays_menuState extends State<tab2_todays_menu>
    with TickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now();
  String selectedMeal = '아침';
  PageController _pageController = PageController(initialPage: 0);
  int current_index = 1;

  // menu 형식 결정, 더미 데이터
  // 가게 이름, 사진(있으면), 별점, 주 메뉴, 국, 밥, 반찬1, 반찬2, 반찬3 순...
  List<List<String>> breakfast = [
    [
      '카이마루',
      "https://via.placeholder.com/400",
      '4.0',
      '밥',
      '국 1',
      '주 메뉴 1',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ],
    [
      '교수회관',
      "https://via.placeholder.com/400",
      '4.0',
      '밥',
      '국 1',
      '주 메뉴 2',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ],
    [
      '서측식당',
      "https://via.placeholder.com/400",
      '4.0',
      '밥',
      '국 1',
      '주 메뉴 3',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ],
    [
      '동측식당',
      "https://via.placeholder.com/400",
      '4.0',
      '밥',
      '국 1',
      '주 메뉴 4',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ]
  ];
  List<List<String>> lunch = [
    [
      '동측식당',
      "https://via.placeholder.com/400",
      '4.0',
      '밥',
      '국 1',
      '주 메뉴 12',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ],
    [
      '카이마루',
      "https://via.placeholder.com/400",
      '4.0',
      '밥',
      '국 1',
      '주 메뉴 13',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ],
    [
      '카이마루',
      "https://via.placeholder.com/400",
      '4.0',
      '밥',
      '국 1',
      '주 메뉴 14',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ],
    [
      '교수회관',
      "https://via.placeholder.com/400",
      '4.0',
      '밥',
      '국 1',
      '주 메뉴 15',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ],
    [
      '서측식당',
      "https://via.placeholder.com/400",
      '4.0',
      '밥',
      '국 1',
      '주 메뉴 17',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ]
  ];
  List<List<String>> dinner = [
    [
      '서측식당',
      "https://via.placeholder.com/400",
      '4.0',
      '밥',
      '국 1',
      '주 메뉴 21',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ],
    [
      '카이마루',
      "https://via.placeholder.com/400",
      '4.0',
      '밥',
      '국 1',
      '주 메뉴 22',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ],
    [
      '교수회관',
      "https://via.placeholder.com/400",
      '4.0',
      '밥',
      '국 1',
      '주 메뉴 23',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ],
    [
      '동측식당',
      "https://via.placeholder.com/400",
      '4.0',
      '밥',
      '국 1',
      '주 메뉴 24',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ]
  ];
  int _pageCount = 0;
  List<List<String>> menu = [];
  List<bool> isSelected = [true, false, false];

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

  String userID = "UserNickname"; // 닉네임

  Future<void> _loadUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getString('userID') ?? '';
    });
  }

  void updateMenu() {
    setState(() {
      switch (selectedMeal) {
        case '아침':
          menu = [breakfast[breakfast.length - 1]] + breakfast + [breakfast[0]];
          _pageCount = menu.length;
          break;
        case '점심':
          menu = [lunch[lunch.length - 1]] + lunch + [lunch[0]];
          _pageCount = menu.length;
          break;
        default:
          menu = [dinner[dinner.length - 1]] + dinner + [dinner[0]];
          _pageCount = menu.length;
          break;
      }
    });
  }

  Future<void> fetchMenus(String Date) async {
    print(Date);
    print(Date + ' ${dotenv.env['SERVER_URL']}/menu/getmenu?date=$Date');
    final response = await http
        .get(Uri.parse('${dotenv.env['SERVER_URL']}/menu/getmenu?date=$Date'));

    // 가게 이름, 사진(있으면), 별점, 주 메뉴, 국, 밥, 반찬1, 반찬2, 반찬3 순...
    // Should Repair
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print(jsonResponse);
      setState(() {
        breakfast = [];
        lunch = [];
        dinner = [];

        for (var i = 0; i < jsonResponse.length; i++) {
          if (jsonResponse[i]["time"] == 1) {
            if (breakfast.isNotEmpty) {
              bool a = false;
              for (var j in breakfast) {
                if (j[0] == "카이마루" && jsonResponse[i]["place"] == "fclt") {
                  j.add(jsonResponse[i]["foodName"]);
                  a = true;
                  break;
                } else if (j[0] == "교수회관" &&
                    jsonResponse[i]["place"] == "emp") {
                  j.add(jsonResponse[i]["foodName"]);
                  a = true;
                  break;
                } else if (j[0] == "서측식당" &&
                    jsonResponse[i]["place"] == "west1") {
                  j.add(jsonResponse[i]["foodName"]);
                  a = true;
                  break;
                } else if (j[0] == jsonResponse[i]["place"]) {
                  j.add(jsonResponse[i]["foodName"]);
                  a = true;
                  break;
                }
              }
              if (!a) {
                List<String> subList = [];
                if (jsonResponse[i]["place"] == "fclt") {
                  subList.add("카이마루");
                } else if (jsonResponse[i]["place"] == "emp") {
                  subList.add("교수회관");
                } else if (jsonResponse[i]["place"] == "west1") {
                  subList.add("서측식당");
                } else {
                  subList.add(jsonResponse[i]["place"]);
                }
                // 이미지
                // subList.add('assets/sample_image.jpg');
                subList.add(jsonResponse[i]["image"] ??
                    "https://via.placeholder.com/400");
                // 별점
                // subList.add("4.0");
                subList.add(jsonResponse[i]["starRating"].toString());
                subList.add(jsonResponse[i]["foodName"]);
                breakfast.add(subList);
              }
            } else {
              List<String> subList = [];
              if (jsonResponse[i]["place"] == "fclt") {
                subList.add("카이마루");
              } else if (jsonResponse[i]["place"] == "emp") {
                subList.add("교수회관");
              } else if (jsonResponse[i]["place"] == "west1") {
                subList.add("서측식당");
              } else {
                subList.add(jsonResponse[i]["place"]);
              }
              // 이미지
              // subList.add('assets/sample_image.jpg');
              subList.add(jsonResponse[i]["image"] ??
                  "https://via.placeholder.com/400");
              // 별점
              // subList.add("4.0");
              subList.add(jsonResponse[i]["starRating"].toString());
              subList.add(jsonResponse[i]["foodName"]);
              breakfast.add(subList);
            }
          } else if (jsonResponse[i]["time"] == 2) if (lunch.isNotEmpty) {
            bool a = false;
            for (var j in lunch) {
              if (j[0] == "카이마루" && jsonResponse[i]["place"] == "fclt") {
                j.add(jsonResponse[i]["foodName"]);
                a = true;
                break;
              } else if (j[0] == "교수회관" && jsonResponse[i]["place"] == "emp") {
                j.add(jsonResponse[i]["foodName"]);
                a = true;
                break;
              } else if (j[0] == "서측식당" &&
                  jsonResponse[i]["place"] == "west1") {
                j.add(jsonResponse[i]["foodName"]);
                a = true;
                break;
              } else if (j[0] == jsonResponse[i]["place"]) {
                j.add(jsonResponse[i]["foodName"]);
                a = true;
                break;
              }
            }
            if (!a) {
              List<String> subList = [];
              if (jsonResponse[i]["place"] == "fclt") {
                subList.add("카이마루");
              } else if (jsonResponse[i]["place"] == "emp") {
                subList.add("교수회관");
              } else if (jsonResponse[i]["place"] == "west1") {
                subList.add("서측식당");
              } else {
                subList.add(jsonResponse[i]["place"]);
              }
              // 이미지
              // subList.add('assets/sample_image.jpg');
              subList.add(jsonResponse[i]["image"] ??
                  "https://via.placeholder.com/400");
              // 별점
              // subList.add("4.0");
              subList.add(jsonResponse[i]["starRating"].toString());
              subList.add(jsonResponse[i]["foodName"]);
              lunch.add(subList);
            }
          } else {
            List<String> subList = [];
            if (jsonResponse[i]["place"] == "fclt") {
              subList.add("카이마루");
            } else if (jsonResponse[i]["place"] == "emp") {
              subList.add("교수회관");
            } else if (jsonResponse[i]["place"] == "west1") {
              subList.add("서측식당");
            } else {
              subList.add(jsonResponse[i]["place"]);
            }
            // 이미지
            // subList.add('assets/sample_image.jpg');
            subList.add(
                jsonResponse[i]["image"] ?? "https://via.placeholder.com/400");
            // 별점
            // subList.add("4.0");
            subList.add(jsonResponse[i]["starRating"].toString());
            subList.add(jsonResponse[i]["foodName"]);
            lunch.add(subList);
          }
          else if (dinner.isNotEmpty) {
            bool a = false;
            for (var j in dinner) {
              if (j[0] == "카이마루" && jsonResponse[i]["place"] == "fclt") {
                j.add(jsonResponse[i]["foodName"]);
                a = true;
                break;
              } else if (j[0] == "교수회관" && jsonResponse[i]["place"] == "emp") {
                j.add(jsonResponse[i]["foodName"]);
                a = true;
                break;
              } else if (j[0] == "서측식당" &&
                  jsonResponse[i]["place"] == "west1") {
                j.add(jsonResponse[i]["foodName"]);
                a = true;
                break;
              } else if (j[0] == jsonResponse[i]["place"]) {
                j.add(jsonResponse[i]["foodName"]);
                a = true;
                break;
              }
            }
            if (!a) {
              List<String> subList = [];
              if (jsonResponse[i]["place"] == "fclt") {
                subList.add("카이마루");
              } else if (jsonResponse[i]["place"] == "emp") {
                subList.add("교수회관");
              } else if (jsonResponse[i]["place"] == "west1") {
                subList.add("서측식당");
              } else {
                subList.add(jsonResponse[i]["place"]);
              }
              // 이미지
              // subList.add('assets/sample_image.jpg');
              subList.add(jsonResponse[i]["image"] ??
                  "https://via.placeholder.com/400");
              // 별점
              // subList.add("4.0");
              subList.add(jsonResponse[i]["starRating"].toString());
              subList.add(jsonResponse[i]["foodName"]);
              dinner.add(subList);
            }
          } else {
            List<String> subList = [];
            if (jsonResponse[i]["place"] == "fclt") {
              subList.add("카이마루");
            } else if (jsonResponse[i]["place"] == "emp") {
              subList.add("교수회관");
            } else if (jsonResponse[i]["place"] == "west1") {
              subList.add("서측식당");
            } else {
              subList.add(jsonResponse[i]["place"]);
            }
            // 이미지
            // subList.add('assets/sample_image.jpg');
            subList.add(
                jsonResponse[i]["image"] ?? "https://via.placeholder.com/400");
            // 별점
            // subList.add("4.0");
            subList.add(jsonResponse[i]["starRating"].toString());
            subList.add(jsonResponse[i]["foodName"]);
            dinner.add(subList);
          }
        }
        SortMenu(breakfast);
        SortMenu(lunch);
        SortMenu(dinner);
        updateMenu();
      });
    } else {
      setState(() {
        breakfast = [
          [
            '카이마루',
            "https://via.placeholder.com/400",
            '4.0',
            '밥',
            '국 1',
            '주 메뉴 1',
            '반찬 1',
            '반찬 2',
            '반찬 3'
          ],
          [
            '교수회관',
            "https://via.placeholder.com/400",
            '4.0',
            '밥',
            '국 1',
            '주 메뉴 2',
            '반찬 1',
            '반찬 2',
            '반찬 3'
          ],
          [
            '서측식당',
            "https://via.placeholder.com/400",
            '4.0',
            '밥',
            '국 1',
            '주 메뉴 3',
            '반찬 1',
            '반찬 2',
            '반찬 3'
          ],
          [
            '동측식당',
            "https://via.placeholder.com/400",
            '4.0',
            '밥',
            '국 1',
            '주 메뉴 4',
            '반찬 1',
            '반찬 2',
            '반찬 3'
          ]
        ];
        lunch = [
          [
            '동측식당',
            "https://via.placeholder.com/400",
            '4.0',
            '밥',
            '국 1',
            '주 메뉴 12',
            '반찬 1',
            '반찬 2',
            '반찬 3'
          ],
          [
            '카이마루',
            "https://via.placeholder.com/400",
            '4.0',
            '밥',
            '국 1',
            '주 메뉴 13',
            '반찬 1',
            '반찬 2',
            '반찬 3'
          ],
          [
            '카이마루',
            "https://via.placeholder.com/400",
            '4.0',
            '밥',
            '국 1',
            '주 메뉴 14',
            '반찬 1',
            '반찬 2',
            '반찬 3'
          ],
          [
            '교수회관',
            "https://via.placeholder.com/400",
            '4.0',
            '밥',
            '국 1',
            '주 메뉴 15',
            '반찬 1',
            '반찬 2',
            '반찬 3'
          ],
          [
            '서측식당',
            "https://via.placeholder.com/400",
            '4.0',
            '밥',
            '국 1',
            '주 메뉴 17',
            '반찬 1',
            '반찬 2',
            '반찬 3'
          ]
        ];
        dinner = [
          [
            '서측식당',
            "https://via.placeholder.com/400",
            '4.0',
            '밥',
            '국 1',
            '주 메뉴 21',
            '반찬 1',
            '반찬 2',
            '반찬 3'
          ],
          [
            '카이마루',
            "https://via.placeholder.com/400",
            '4.0',
            '밥',
            '국 1',
            '주 메뉴 22',
            '반찬 1',
            '반찬 2',
            '반찬 3'
          ],
          [
            '교수회관',
            "https://via.placeholder.com/400",
            '4.0',
            '밥',
            '국 1',
            '주 메뉴 23',
            '반찬 1',
            '반찬 2',
            '반찬 3'
          ],
          [
            '동측식당',
            "https://via.placeholder.com/400",
            '4.0',
            '밥',
            '국 1',
            '주 메뉴 24',
            '반찬 1',
            '반찬 2',
            '반찬 3'
          ]
        ];
        updateMenu();
      });
      throw Exception(
          'Failed to load posts: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  // 알레르기 적은 순, 좋아하는 메뉴 많은 순으로 정렬
  Future<List<List<String>>> SortMenu(List<List<String>> menu) async {
    try {
      // 각 메뉴 항목에 대해 알러지 개수를 계산하고 이를 포함한 새로운 리스트를 생성합니다.
      List<Map<String, dynamic>> menuWithAllergyCount =
          await Future.wait(menu.map((menu) async {
        int allergyCount = await getAllergyCount(menu.sublist(3));
        return {'menu': menu, 'allergyCount': allergyCount};
      }).toList());

      // 알러지 개수를 기준으로 정렬합니다.
      menuWithAllergyCount
          .sort((a, b) => a['allergyCount'].compareTo(b['allergyCount']));

      // 정렬된 리스트에서 원래 메뉴 리스트를 추출합니다.
      List<List<String>> sortedMenu1 = menuWithAllergyCount
          .map((item) => List<String>.from(item['menu']))
          .toList();

      List<Map<String, dynamic>> menuWithFavorite =
          await Future.wait(menu.map((menu) async {
        int favoriteCount = await getFavoriteCount(menu.sublist(3));
        return {'menu': menu, 'FavoriteCount': favoriteCount};
      }).toList());

      // 알러지 개수를 기준으로 정렬합니다.
      menuWithFavorite
          .sort((a, b) => a['FavoriteCount'].compareTo(b['FavoriteCount']));

      // 정렬된 리스트에서 원래 메뉴 리스트를 추출합니다.
      List<List<String>> sortedMenu2 = menuWithFavorite
          .map((item) => List<String>.from(item['menu']))
          .toList();

      // 정렬된 데이터 사용
      return sortedMenu2;
    } catch (e) {
      return menu;
    }
  }

  // 가게 이름, 사진(있으면), 별점, 주 메뉴, 국, 밥, 반찬1, 반찬2, 반찬3 순...
  Future<int> SortMenuByAllergy(List<String> a, List<String> b) async {
    int a1 = await getAllergyCount(a.sublist(3));
    int b1 = await getAllergyCount(b.sublist(3));
    if (a1 < b1)
      return 1;
    else
      ;
    return -1;
  }

  // 가게 이름, 사진(있으면), 별점, 주 메뉴, 국, 밥, 반찬1, 반찬2, 반찬3 순...
  Future<int> SortMenuByFavorite(List<String> a, List<String> b) async {
    int a1 = await getFavoriteCount(a.sublist(3));
    int b1 = await getFavoriteCount(b.sublist(3));
    if (a1 < b1)
      return -1;
    else
      ;
    return 1;
  }

  Future<int> getAllergyCount(List<String> a) async {
    int cnt = 0;
    List<int> allergy = [];
    for (var i in a) {
      final response = await http
          .get(Uri.parse('${dotenv.env['SERVER_URL']}/food?foodName=$i'));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        allergy = jsonResponse[0];
        for (var j in allergy) {
          if (_allergies[_allergies_map[j]] == true) {
            cnt++;
            break;
          }
        }
      } else {
        throw Exception('Failed to load posts');
      }
    }
    return cnt;
  }

  Future<int> getFavoriteCount(List<String> a) async {
    int cnt = 0;
    bool favorite = false;
    for (var i in a) {
      final response = await http.get(Uri.parse(
          '${dotenv.env['SERVER_URL']}/food/get/heart?foodName=$i&userID=$userID'));

      if (response.statusCode == 200) {
        Map<String, bool> jsonResponse = json.decode(response.body);
        favorite = jsonResponse["heart"]!;
        if (favorite == true) {
          cnt++;
        }
      } else {
        throw Exception('Failed to load posts');
      }
    }
    return cnt;
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

  @override
  void initState() {
    super.initState();

    _loadAllergies();

    _loadUserID();

    fetchMenus(DateFormat('yyyy-MM-dd').format(_selectedDate));

    menu = [breakfast[breakfast.length - 1]] + breakfast + [breakfast[0]];

    if (_selectedDate.hour < 8)
      selectedMeal = '아침';
    else if (_selectedDate.hour < 13 ||
        (_selectedDate.hour == 13 && _selectedDate.minute <= 30))
      selectedMeal = '점심';
    else
      selectedMeal = '저녁';

    _pageCount = menu.length;

    _pageController = PageController(initialPage: 1)
      ..addListener(() {
        int nextPage = _pageController.page!.round();
        if (nextPage >= _pageCount - 1) {
          _pageController.jumpToPage(1);
        } else if (nextPage < 1) {
          _pageController.jumpToPage(_pageCount - 2);
        }
        setState(() {
          current_index = _pageController.page!.round();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvoked: (bool a) async {
          SystemNavigator.pop();
        },
        child: Scaffold(
          backgroundColor: Color(0xfff5f7fa),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(children: [
              Text(
                "오늘의 메뉴",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ]),
            actions: [
              IconButton(
                icon: Icon(Icons.person_outline, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => my_page(),
                    ),
                  );
                },
              ),
              SizedBox(width: 8),
            ],
            backgroundColor: Color(0xfff5f7fa),
            elevation: 0,
          ),
          body: Column(children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.chevron_left,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedDate =
                                  _selectedDate.subtract(Duration(days: 1));
                              fetchMenus(DateFormat('yyyy-MM-dd')
                                  .format(_selectedDate));
                            });
                          },
                        ),
                        Row(children: <Widget>[
                          Text(
                            DateFormat('yyyy년 MM월 dd일').format(_selectedDate),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedMeal,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedMeal = newValue!;
                                  updateMenu();
                                });
                              },
                              items: <String>[
                                '아침',
                                '점심',
                                '저녁'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ]),
                        IconButton(
                          icon: Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedDate =
                                  _selectedDate.add(Duration(days: 1));
                              fetchMenus(DateFormat('yyyy-MM-dd')
                                  .format(_selectedDate));
                            });
                          },
                        ),
                      ]),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 480,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _pageCount,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => show_cafeteria_menu(
                                      date: _selectedDate,
                                      time: selectedMeal,
                                      menu: menu[index]),
                                ),
                              );
                            },
                            child: Hero(
                                tag: 'menucard',
                                child: Card(
                                  color: Colors.white,
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          child: Image.network(
                                            menu[index][1],
                                            fit: BoxFit.cover,
                                            height: 200,
                                            width: double.infinity,
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${menu[index][5]}',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.star,
                                                    color: Colors.amber),
                                                Text(
                                                  '${menu[index][2]}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          '장소: ' + '${menu[index][0]}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        ...menu[index]
                                            .sublist(3, 8)
                                            .map((item) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 4.0),
                                                  child: Text(
                                                    '   - ' + item,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                      ],
                                    ),
                                  ),
                                )));
                      },
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        List.generate(_pageCount - 2, _buildPageIndicator),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => menu_show_one(
                              date: _selectedDate,
                              breakfast: breakfast,
                              lunch: lunch,
                              dinner: dinner),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            SizedBox(height: 8),
                            Container(
                              width: 36,
                              height: 36,
                              child: Image.asset(
                                "assets/free-icon-font-list.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              "모아보기",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              monthly_calendar(place: menu[current_index][0]),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            SizedBox(height: 8),
                            Container(
                              width: 36,
                              height: 36,
                              child: Image.asset(
                                "assets/free-icon-font-calendar.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              "월별 식단",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => write_review(
                              date: _selectedDate,
                              time: selectedMeal,
                              place: menu[current_index][0]),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            SizedBox(height: 8),
                            Container(
                              width: 36,
                              height: 36,
                              child: Image.asset(
                                "assets/free-icon-font-edit.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              "리뷰 작성",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ]),
        ));
  }

  Widget _buildPageIndicator(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      width: 12.0,
      height: 12.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: current_index == index + 1 ? Colors.blue : Colors.grey,
      ),
    );
  }
}
