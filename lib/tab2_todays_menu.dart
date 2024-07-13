import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ChangeTextScreen.dart';
import 'ShowCafeteriaMenu.dart';
import 'SamplePage.dart';
import 'myPage.dart';
import 'MonthlyCalendar.dart';

class tab2_todays_menu extends StatefulWidget {
  const tab2_todays_menu({super.key});

  @override
  _todays_menuState createState() => _todays_menuState();
}

class _todays_menuState extends State<tab2_todays_menu>
    with TickerProviderStateMixin {
  String selectedMeal = '아침';
  String filter_name = "식당별";
  DateTime _selectedDate = DateTime.now();
  final PageController _pageController = PageController(initialPage: 0);
  List<List<String>> breakfast = [
    ['1', '주 메뉴 1', '국 1', '반찬 1', '반찬 2', '반찬 3'],
    ['1.1', '주 메뉴 2', '국 1', '반찬 1', '반찬 2', '반찬 3'],
    ['2', '주 메뉴 3', '국 1', '반찬 1', '반찬 2', '반찬 3'],
    ['3', '주 메뉴 4', '국 1', '반찬 1', '반찬 2', '반찬 3']
  ];
  List<List<String>> lunch = [
    ['카이마루', '주 메뉴 1', '국 1', '반찬 1', '반찬 2', '반찬 3'],
    ['카이마루', '주 메뉴 2', '국 1', '반찬 1', '반찬 2', '반찬 3'],
    ['교수회관', '주 메뉴 3', '국 1', '반찬 1', '반찬 2', '반찬 3'],
    ['동측식당', '주 메뉴 4', '국 1', '반찬 1', '반찬 2', '반찬 3']
  ];
  List<List<String>> dinner = [
    ['카이마루', '주 메뉴 1', '국 1', '반찬 1', '반찬 2', '반찬 3'],
    ['카이마루', '주 메뉴 2', '국 1', '반찬 1', '반찬 2', '반찬 3'],
    ['교수회관', '주 메뉴 3', '국 1', '반찬 1', '반찬 2', '반찬 3'],
    ['동측식당', '주 메뉴 4', '국 1', '반찬 1', '반찬 2', '반찬 3']
  ];
  final List<String> images = [
    'assets/sample_image.jpg',
    'assets/sample_image.jpg',
    'assets/sample_image.jpg',
    'assets/sample_image.jpg',
  ];
  List<List<String>> menu = [];
  List<bool> isSelected = [true, false, false];

  void updateMenu() {
    setState(() {
      switch (selectedMeal) {
        case '아침':
          menu = breakfast;
          break;
        case '점심':
          menu = lunch;
          break;
        default:
          menu = dinner;
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

  @override
  void initState() {
    super.initState();
    menu = breakfast;
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
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
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
              Container(
                height: 380,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: menu.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => show_cafeteria_menu(),
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
                                  images[index],
                                  fit: BoxFit.cover,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${menu[index][0]} ${menu[index][1]}',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.star),
                                        Text(" 4.0")
                                      ],
                                    )
                                  ],
                                ),
                                Text(
                                  '${menu[index][2]}',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  '${menu[index][3]}',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                  },
                ),
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
                        builder: (context) => sample_page(),
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
                        builder: (context) => sample_page(),
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
                        Text("리뷰 쓰기"),
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
