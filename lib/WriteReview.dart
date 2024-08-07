import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:shared_preferences/shared_preferences.dart';

class write_review extends StatefulWidget {
  const write_review(
      {super.key, required this.date, required this.time, required this.place});

  final DateTime date;
  final String time;
  final String place;

  @override
  _WriteReviewState createState() => _WriteReviewState();
}

class _WriteReviewState extends State<write_review>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  double _rating = 0;

  DateTime _selectedDate = DateTime.now();
  String _selectedMealTime = '아침';
  String _selectedLocation = '카이마루';
  String _selectedMenu = 'menu1';

  final List<String> _mealTimes = ['아침', '점심', '저녁'];
  final List<String> _locations = ['카이마루', '동측식당', '서측식당', '교수회관'];
  List<String> _menus = ['menu1', 'menu2', 'menu3'];

  String userID = "";

  Future<void> _loadUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID') ?? '';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
      await fetchMenus(DateFormat('yyyy-MM-dd').format(_selectedDate));
    }
  }

  List<List<String>> breakfast = [];
  List<List<String>> lunch = [];
  List<List<String>> dinner = [];
  List<List<String>> menu = [];

  Future<void> fetchMenus(String Date) async {
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

  void updateMenu() {
    setState(() {
      switch (_selectedMealTime) {
        case '아침':
          menu = [breakfast[breakfast.length - 1]] + breakfast + [breakfast[0]];
          takeLocation();
          break;
        case '점심':
          menu = [lunch[lunch.length - 1]] + lunch + [lunch[0]];
          takeLocation();
          break;
        default:
          menu = [dinner[dinner.length - 1]] + dinner + [dinner[0]];
          takeLocation();
          break;
      }
    });
  }

  void takeLocation() {
    for (var i in menu) {
      if (i[0] == _selectedLocation) {
        _menus = i.sublist(3);
        _selectedMenu = _menus[0];
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.date;
    _selectedMealTime = widget.time;
    _selectedLocation = widget.place;
    fetchMenus(DateFormat('yyyy-MM-dd').format(_selectedDate));
    _loadUserID();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('${dotenv.env['SERVER_URL']}/review/write'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'foodName': _selectedMenu,
          'userID': userID,
          'starRating': _rating.toString(),
          'content': _reviewController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('리뷰가 제출되었습니다.')),
        );
        _reviewController.clear();
        setState(() {
          _rating = 0;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('리뷰 제출을 실패했습니다. 오류코드: ${response.statusCode} ${response.reasonPhrase}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f7fa),
      appBar: AppBar(
        title: Text('리뷰 작성', style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xfff5f7fa),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('메뉴',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ListTile(
                title: Text('선택한 날짜: ${DateFormat('yyyy년 MM월 dd일').format(
                    _selectedDate)}'),
                trailing: Icon(Icons.calendar_today, color: Colors.black),
                onTap: () => _selectDate(context),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: _selectedMealTime,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedMealTime = newValue!;
                        updateMenu();
                      });
                    },
                    items: _mealTimes.map<DropdownMenuItem<String>>((
                        String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DropdownButton<String>(
                    value: _selectedLocation,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLocation = newValue!;
                        takeLocation();
                      });
                    },
                    items: _locations.map<DropdownMenuItem<String>>((
                        String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DropdownButton<String>(
                    value: _selectedMenu,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedMenu = newValue!;
                      });
                    },
                    items: _menus.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text('평점',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1.0;
                      });
                    },
                  );
                }),
              ),
              SizedBox(height: 16),
              Text('리뷰',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              TextFormField(
                controller: _reviewController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '리뷰를 입력하세요',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '리뷰를 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                    onPressed: _submitReview,
                    child: Text('리뷰 제출', style: TextStyle(fontWeight: FontWeight.w800),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}