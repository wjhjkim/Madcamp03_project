import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:intl/intl.dart';

class monthly_calendar extends StatefulWidget {
  const monthly_calendar({super.key, required this.place});

  final String place;

  @override
  _monthly_calendar createState() => _monthly_calendar();
}

class _monthly_calendar extends State<monthly_calendar>
    with TickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  int? selectedDay;
  final List<String> _locations = ['카이마루', '동측식당', '서측식당', '교수회관'];
  String _selectedLocation = '카이마루';

  List<List<String>> breakfast = [
    [
      '카이마루',
      'assets/sample_image.jpg',
      '가격',
      '4.0',
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
      '4.0',
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
      '4.0',
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
      '4.0',
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
      '4.0',
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
      '4.0',
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
      '4.0',
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
      '4.0',
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
      '4.0',
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
      '4.0',
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
      '4.0',
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
      '4.0',
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
      '4.0',
      '주 메뉴 4',
      '국 1',
      '밥',
      '반찬 1',
      '반찬 2',
      '반찬 3'
    ]
  ];

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.place;
    // fetchMenus(DateFormat('yyyy년 MM월 dd일').format(selectedDate));
  }

  Future<void> fetchMenus(String Date) async {
    final response = await http.get(Uri.parse('${dotenv.env['SERVER_URL']}/menu/getmenu?Date=$Date'));

    // 가게 이름, 사진(있으면), 가격, 별점, 주 메뉴, 국, 밥, 반찬1, 반찬2, 반찬3 순...
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      setState(() {
        breakfast = jsonResponse['아침'];
        lunch = jsonResponse['점심'];
        dinner = jsonResponse['저녁'];
      });
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('월별 식단표'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      selectedDate =
                          DateTime(selectedDate.year, selectedDate.month - 1);
                      selectedDay = null; // 새로운 달로 변경 시 선택된 날을 초기화
                    });
                  },
                ),
                Row(
                  children: [
                    Text(
                      '${selectedDate.year}년 ${selectedDate.month}월 ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String>(
                      value: _selectedLocation,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedLocation = newValue!;
                        });
                      },
                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                      items: _locations
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    setState(() {
                      selectedDate =
                          DateTime(selectedDate.year, selectedDate.month + 1);
                      selectedDay = null; // 새로운 달로 변경 시 선택된 날을 초기화
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Table(
                    border: TableBorder.all(),
                    children: _buildCalendar(selectedDate),
                  ),
                  if (selectedDay != null) _buildMealInfo(selectedDay!),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<TableRow> _buildCalendar(DateTime date) {
    List<TableRow> rows = [];
    List<String> daysOfWeek = ['일', '월', '화', '수', '목', '금', '토'];
    rows.add(
      TableRow(
        children: daysOfWeek
            .map((day) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text(day)),
                ))
            .toList(),
      ),
    );

    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    int firstWeekday = firstDayOfMonth.weekday % 7;
    int daysInMonth = DateTime(date.year, date.month + 1, 0).day;

    List<Widget> cells = [];

    for (int i = 0; i < firstWeekday; i++) {
      cells.add(Container());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      cells.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDay = day;
              // fetchMenus(DateFormat('yyyy년 MM월 dd일').format(selectedDate));
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                day.toString(),
                style: TextStyle(
                  fontWeight:
                      selectedDay == day ? FontWeight.bold : FontWeight.normal,
                  color: selectedDay == day ? Colors.blue : Colors.black,
                ),
              ),
            ),
          ),
        ),
      );
    }

    while (cells.length % 7 != 0) {
      cells.add(Container());
    }

    for (int i = 0; i < cells.length; i += 7) {
      rows.add(TableRow(children: cells.sublist(i, i + 7)));
    }

    return rows;
  }

  Widget _buildMealInfo(int day) {
    // 실제 데이터로 대체할 수 있습니다.
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$day일 ${_selectedLocation} 식단',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          for (var i = 0; i < breakfast.length; i++)
            if (breakfast[i][0] == _selectedLocation)
              Text('아침: ' + breakfast[i].sublist(4).join(', ')),
          for (var i = 0; i < lunch.length; i++)
            if (lunch[i][0] == _selectedLocation)
              Text('점심: ' + lunch[i].sublist(4).join(', ')),
          for (var i = 0; i < dinner.length; i++)
            if (dinner[i][0] == _selectedLocation)
              Text('저녁: ' + dinner[i].sublist(4).join(', ')),
        ],
      ),
    );
  }
}
