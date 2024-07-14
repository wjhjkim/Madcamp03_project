import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class menu_show_one extends StatefulWidget {
  const menu_show_one({super.key, required this.date});

  final DateTime date;

  @override
  _show_menu createState() => _show_menu();
}

class _show_menu extends State<menu_show_one>
    with TickerProviderStateMixin {
  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    date = widget.date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(DateFormat('yyyy년 MM월 dd일').format(date)),
        ),
        body: Text("Sample")
    );
  }
}