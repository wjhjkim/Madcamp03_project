import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

class monthly_calendar extends StatefulWidget {
  const monthly_calendar({super.key, required this.place});

  final String place;

  @override
  _MonthlyCalendarState createState() => _MonthlyCalendarState();
}

class _MonthlyCalendarState extends State<monthly_calendar>
    with TickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  int? selectedDay;
  final List<String> _locations = ['카이마루', '동측식당', '서측식당', '교수회관'];
  String _selectedLocation = '카이마루';

  List<List<String>> breakfast = [];
  List<List<String>> lunch = [];
  List<List<String>> dinner = [];

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.place;
    fetchMenus(DateFormat('yyyy-MM-dd').format(selectedDate));
  }

  Future<void> fetchMenus(String Date) async {
    final response = await http
        .get(Uri.parse('${dotenv.env['SERVER_URL']}/menu/getmenu?date=$Date'));

    // 가게 이름, 사진(있으면), 별점, 주 메뉴, 국, 밥, 반찬1, 반찬2, 반찬3 순...
    // Should Repair
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      setState(() {
        breakfast = [];
        lunch = [];
        dinner = [];

        for (var item in jsonResponse) {
          List<String> subList = [];
          if (item["place"] == "fclt") {
            subList.add("카이마루");
          } else if (item["place"] == "emp") {
            subList.add("교수회관");
          } else if (item["place"] == "west1") {
            subList.add("서측식당");
          } else {
            subList.add(item["place"]);
          }
          subList.add('assets/sample_image.jpg'); // 이미지
          subList.add("4.0"); // 별점
          subList.add(item["foodName"]);

          if (item["time"] == 1) {
            breakfast.add(subList);
          } else if (item["time"] == 2) {
            lunch.add(subList);
          } else {
            dinner.add(subList);
          }
        }
      });
    } else {
      setState(() {
        // 예제 데이터로 초기화
        breakfast = [
          ['카이마루', 'assets/sample_image.jpg', '4.0', '주 메뉴 1', '국 1', '밥', '반찬 1', '반찬 2', '반찬 3'],
          ['교수회관', 'assets/sample_image.jpg', '4.0', '주 메뉴 2', '국 1', '밥', '반찬 1', '반찬 2', '반찬 3'],
          ['서측식당', 'assets/sample_image.jpg', '4.0', '주 메뉴 3', '국 1', '밥', '반찬 1', '반찬 2', '반찬 3'],
          ['동측식당', 'assets/sample_image.jpg', '4.0', '주 메뉴 4', '국 1', '밥', '반찬 1', '반찬 2', '반찬 3']
        ];
        lunch = [
          ['동측식당', 'assets/sample_image.jpg', '4.0', '주 메뉴 1', '국 1', '밥', '반찬 1', '반찬 2', '반찬 3'],
          ['카이마루', 'assets/sample_image.jpg', '4.0', '주 메뉴 2', '국 1', '밥', '반찬 1', '반찬 2', '반찬 3'],
          ['카이마루', 'assets/sample_image.jpg', '4.0', '주 메뉴 3', '국 1', '밥', '반찬 1', '반찬 2', '반찬 3'],
          ['교수회관', 'assets/sample_image.jpg', '4.0', '주 메뉴 4', '국 1', '밥', '반찬 1', '반찬 2', '반찬 3'],
          ['서측식당', 'assets/sample_image.jpg', '4.0', '주 메뉴 5', '국 1', '밥', '반찬 1', '반찬 2', '반찬 3']
        ];
        dinner = [
          ['서측식당', 'assets/sample_image.jpg', '4.0', '주 메뉴 1', '국 1', '밥', '반찬 1', '반찬 2', '반찬 3'],
          ['카이마루', 'assets/sample_image.jpg', '4.0', '주 메뉴 2', '국 1', '밥', '반찬 1', '반찬 2', '반찬 3'],
          ['교수회관', 'assets/sample_image.jpg', '4.0', '주 메뉴 3', '국 1', '밥', '반찬 1', '반찬 2', '반찬 3'],
          ['동측식당', 'assets/sample_image.jpg', '4.0', '주 메뉴 4', '국 1', '밥', '반찬 1', '반찬 2', '반찬 3']
        ];
      });
      throw Exception('Failed to load posts: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('월별 식단표', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime(selectedDate.year, selectedDate.month - 1);
                      selectedDay = null; // 새로운 달로 변경 시 선택된 날을 초기화
                    });
                  },
                ),
                Row(
                  children: [
                    Text(
                      '${selectedDate.year}년 ${selectedDate.month}월 ',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String>(
                      value: _selectedLocation,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedLocation = newValue!;
                        });
                      },
                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                      items: _locations.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime(selectedDate.year, selectedDate.month + 1);
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
                    border: TableBorder.all(color: Colors.grey),
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
          child: Center(child: Text(day, style: TextStyle(fontWeight: FontWeight.bold))),
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
            });
            if (selectedDay! < 10)
              fetchMenus(DateFormat('yyyy-MM').format(selectedDate) + "-0" + selectedDay.toString());
            else
              fetchMenus(DateFormat('yyyy-MM').format(selectedDate) + "-" + selectedDay.toString());
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                day.toString(),
                style: TextStyle(
                  fontWeight: selectedDay == day ? FontWeight.bold : FontWeight.normal,
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
              Text('아침: ' + breakfast[i].sublist(3).join(', ')),
          for (var i = 0; i < lunch.length; i++)
            if (lunch[i][0] == _selectedLocation)
              Text('점심: ' + lunch[i].sublist(3).join(', ')),
          for (var i = 0; i < dinner.length; i++)
            if (dinner[i][0] == _selectedLocation)
              Text('저녁: ' + dinner[i].sublist(3).join(', ')),
        ],
      ),
    );
  }
}
