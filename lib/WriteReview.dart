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
  _write_review createState() => _write_review();
}

class _write_review extends State<write_review> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  double _rating = 0;

  DateTime _selectedDate = DateTime.now();
  String _selectedMealTime = '아침';
  String _selectedLocation = '카이마루';
  String _selectedMenu = 'menu1';

  final List<String> _mealTimes = ['아침', '점심', '저녁'];
  final List<String> _locations = ['카이마루', '동측식당', '서측식당', '교수회관'];
  final List<String> _menus = ['menu1', 'menu2', 'menu3'];

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
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.date;
    _selectedMealTime = widget.time;
    _selectedLocation = widget.place;
    // _loadUserID()
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview() async {
    if (_formKey.currentState!.validate()) {
      // 여기에 리뷰를 제출하는 로직을 추가할 수 있습니다.
      final response = await http.post(
        Uri.parse('${dotenv.env['SERVER_URL']}/review/write'),
        // 여기에 실제 서버 URL을 입력하세요
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
          SnackBar(content: Text('리뷰 제출을 실패했습니다. 오류코드: ${response.statusCode}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('리뷰 작성'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '메뉴',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    title: Text(
                        '선택한 날짜: ${DateFormat('yyyy년 MM월 dd일').format(_selectedDate)}'),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context),
                  ),
                  ListTile(
                      title: Row(
                    children: [
                      DropdownButton<String>(
                        value: _selectedMealTime,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedMealTime = newValue!;
                          });
                        },
                        items: _mealTimes
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(width: 10,),
                      DropdownButton<String>(
                        value: _selectedLocation,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedLocation = newValue!;
                          });
                        },
                        items: _locations
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(width: 10,),
                      DropdownButton<String>(
                        value: _selectedMenu,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedMenu = newValue!;
                          });
                        },
                        items: _menus
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ))
                ],
              ),
              SizedBox(height: 8),
              Text(
                '평점',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
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
              Text(
                '리뷰',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
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
                  child: Text('리뷰 제출'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
