import 'package:flutter/material.dart';

class monthly_calendar extends StatefulWidget {
  const monthly_calendar({super.key});

  @override
  _monthly_calendar createState() => _monthly_calendar();
}

class _monthly_calendar extends State<monthly_calendar>
    with TickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  int? selectedDay;

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
                      selectedDate = DateTime(selectedDate.year, selectedDate.month - 1);
                      selectedDay = null; // 새로운 달로 변경 시 선택된 날을 초기화
                    });
                  },
                ),
                Text(
                  '${selectedDate.year}년 ${selectedDate.month}월',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
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
            });
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
            '$day일 식단',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text('아침: 계란후라이, 밥, 김치'),
          Text('점심: 된장찌개, 밥, 나물'),
          Text('저녁: 불고기, 밥, 야채무침'),
        ],
      ),
    );
  }
}
