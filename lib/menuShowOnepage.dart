import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class menu_show_one extends StatefulWidget {
  const menu_show_one(
      {super.key, required this.date, required this.breakfast, required this.lunch, required this.dinner});

  final DateTime date;
  final List<List<String>> breakfast;
  final List<List<String>> lunch;
  final List<List<String>> dinner;

  @override
  _ShowMenuState createState() => _ShowMenuState();
}

class _ShowMenuState extends State<menu_show_one> with TickerProviderStateMixin {
  DateTime date = DateTime.now();
  List<List<String>> breakfast = [];
  List<List<String>> lunch = [];
  List<List<String>> dinner = [];
  final List<String> _locations = ['카이마루', '동측식당', '서측식당', '교수회관'];

  @override
  void initState() {
    super.initState();
    date = widget.date;
    breakfast = widget.breakfast;
    lunch = widget.lunch;
    dinner = widget.dinner;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f7fa),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          DateFormat('yyyy년 MM월 dd일 메뉴').format(date),
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xfff5f7fa),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              _buildMealSection('아침', breakfast),
              SizedBox(height: 24),
              _buildMealSection('점심', lunch),
              SizedBox(height: 24),
              _buildMealSection('저녁', dinner),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealSection(String meal, List<List<String>> menu) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          meal,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _locations.map((location) => _buildLocationSection(location, menu)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection(String location, List<List<String>> menu) {
    List<String> items = [];
    for (var item in menu) {
      if (item[0] == location) {
        items = item.sublist(3);
        break;
      }
    }

    return items.isNotEmpty
        ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 8),
            for (var item in items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  '• $item',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
          ],
        ),
      ),
    ))
        : SizedBox.shrink();
  }
}
