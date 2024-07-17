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
  _show_menu createState() => _show_menu();
}

class _show_menu extends State<menu_show_one>
    with TickerProviderStateMixin {
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
        appBar: AppBar(
          centerTitle: true,
          title: Text(DateFormat('yyyy년 MM월 dd일 메뉴').format(date)),
        ),
        body:
        Column(children: [
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 4,),
              Column(children: [
                Text("아침", style: TextStyle(fontSize: 20),),
                for (var data in _locations)
                  Column(children: [
                    Text(data, style: TextStyle(fontSize: 16),),
                    for (var i in breakfast)
                      if (i[0] == data)
                        Text(i.sublist(3).join("\n"), textAlign: TextAlign.center,)
                  ],)
              ],),
              Column(children: [
                Text("점심", style: TextStyle(fontSize: 20),),
                for (var data in _locations)
                  Column(children: [
                    Text(data, style: TextStyle(fontSize: 16),),
                    for (var i in lunch)
                      if (i[0] == data)
                        Text(i.sublist(3).join("\n"), textAlign: TextAlign.center,)
                  ],)
              ],),
              Column(children: [
                Text("저녁", style: TextStyle(fontSize: 20),),
                for (var data in _locations)
                  Column(children: [
                    Text(data, style: TextStyle(fontSize: 16),),
                    for (var i in dinner)
                      if (i[0] == data)
                        Text(i.sublist(3).join("\n"), textAlign: TextAlign.center,)
                  ],),
              ],),
              SizedBox(width: 4,),
            ],
          )
        ],));
  }
}