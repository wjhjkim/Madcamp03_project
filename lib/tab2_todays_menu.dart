import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ChangeTextScreen.dart';
import 'ShowCafeteriaMenu.dart';
import 'SamplePage.dart';
import 'myPage.dart';
import 'MonthlyCalendar.dart';
import 'WriteReview.dart';
import 'menuShowOnepage.dart';

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

  // menu 형식 결정
  // 가게 이름, 사진(있으면), 가격, 주 메뉴, 국, 밥, 반찬1, 반찬2, 반찬3 순...
  List<List<String>> breakfast = [
    [
      '카이마루',
      'assets/sample_image.jpg',
      '가격',
      '주 메뉴 1',
      '국 1',
      '밥',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ],
    [
      '교수회관',
      'assets/sample_image.jpg',
      '가격',
      '주 메뉴 2',
      '국 1',
      '밥',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ],
    [
      '서측식당',
      'assets/sample_image.jpg',
      '가격',
      '주 메뉴 3',
      '국 1',
      '밥',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ],
    [
      '동측식당',
      'assets/sample_image.jpg',
      '가격',
      '주 메뉴 4',
      '국 1',
      '밥',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ]
  ];
  List<List<String>> lunch = [
    [
      '동측식당',
      'assets/sample_image.jpg',
      '가격',
      '주 메뉴 1',
      '국 1',
      '밥',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ],
    [
      '카이마루',
      'assets/sample_image.jpg',
      '가격',
      '주 메뉴 2',
      '국 1',
      '밥',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ],
    [
      '카이마루',
      'assets/sample_image.jpg',
      '가격',
      '주 메뉴 3',
      '국 1',
      '밥',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ],
    [
      '교수회관',
      'assets/sample_image.jpg',
      '가격',
      '주 메뉴 4',
      '국 1',
      '밥',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ],
    [
      '서측식당',
      'assets/sample_image.jpg',
      '가격',
      '주 메뉴 5',
      '국 1',
      '밥',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ]
  ];
  List<List<String>> dinner = [
    [
      '서측식당',
      'assets/sample_image.jpg',
      '가격',
      '주 메뉴 1',
      '국 1',
      '밥',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ],
    [
      '카이마루',
      'assets/sample_image.jpg',
      '가격',
      '주 메뉴 2',
      '국 1',
      '밥',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ],
    [
      '교수회관',
      'assets/sample_image.jpg',
      '가격',
      '주 메뉴 3',
      '국 1',
      '밥',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ],
    [
      '동측식당',
      'assets/sample_image.jpg',
      '가격',
      '주 메뉴 4',
      '국 1',
      '밥',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ]
  ];
  int _pageCount = 0;
  List<List<String>> menu = [];
  List<bool> isSelected = [true, false, false];

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

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
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

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(children: [
          // SizedBox(
          //   width: 4,
          // ),
          Text(
            "오늘의 메뉴",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ]),
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => my_page(),
                  ),
                );
              },
              child: Icon(Icons.person_outline))
        ],
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 8,
          ),
        ),
        // centerTitle: true,
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
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
                        });
                      },
                    ),
                    Row(children: <Widget>[
                      Text(
                        DateFormat('yyyy년 MM월 dd일').format(_selectedDate),
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedMeal,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedMeal = newValue!;
                              updateMenu();
                            });
                          },
                          items: <String>['아침', '점심', '저녁']
                              .map<DropdownMenuItem<String>>((String value) {
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
                          _selectedDate = _selectedDate.add(Duration(days: 1));
                        });
                      },
                    ),
                  ]),
              Container(
                height: 450,
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
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  menu[index][1],
                                  fit: BoxFit.cover,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${menu[index][3]}',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.amber),
                                        Text(" 4.0")
                                      ],
                                    )
                                  ],
                                ),
                                Text(
                                  '장소: ' + '${menu[index][0]}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '${menu[index][4]}',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  '${menu[index][5]}',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [Text('${menu[index][2]}원')],
                                )
                              ],
                            ),
                          ),
                        ));
                  },
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pageCount - 2, _buildPageIndicator),
              ),
              // _buildFoodListWidget(filter_name),
            ],
          ),
        ),
        // Container(
        //   height: 8,
        //   color: Colors.grey,
        // ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => menu_show_one(),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(children: [
                        Text("메뉴 모아보기"),
                        Image.asset(
                          "assets/sample_image.jpg",
                          fit: BoxFit.cover,
                        ),
                      ]),
                    ),
                  ),
                )),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => monthly_calendar(),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(children: [
                        Text("월별 식단표"),
                        Image.asset(
                          "assets/sample_image.jpg",
                          fit: BoxFit.cover,
                        ),
                      ]),
                    ),
                  ),
                )),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => write_review(date: _selectedDate, time: selectedMeal, place: menu[current_index][0]),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(children: [
                        Text("리뷰 작성하기"),
                        Image.asset(
                          "assets/sample_image.jpg",
                          fit: BoxFit.cover,
                        ),
                      ]),
                    ),
                  ),
                )),
              ],
            )

            // _buildFoodListWidget(filter_name),
            ),
      ]),
    );
  }

  Widget _buildFoodListWidget(String filter_name) {
    switch (filter_name) {
      case '메뉴별':
        return Expanded(
          child: ListView.builder(
            itemCount: menu.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(menu[index][1]),
                  subtitle: Text(menu[index].sublist(2).toString()),
                ),
              );
            },
          ),
        );
      case '식당별':
        return Expanded(
          child: ListView.builder(
            itemCount: menu.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(menu[index][0]),
                  subtitle: ChangeTextScreen(menu: menu[index].sublist(1)),
                  trailing: Text("뭐임?"),
                ),
              );
            },
          ),
        );
      case '개인별':
        return Expanded(
          child: ListView.builder(
            itemCount: menu.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(menu[index][1]),
                  subtitle: Text(menu[index].sublist(2).toString()),
                ),
              );
            },
          ),
        );
      default:
        return Column(
          children: [Text('잘못된 선택입니다.')],
        );
    }
  }
}
//
// class _menuBox extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text("Name", style: TextStyle(color: Colors.blue, fontSize: 20)),
//       ],
//     );
//   }
// }
