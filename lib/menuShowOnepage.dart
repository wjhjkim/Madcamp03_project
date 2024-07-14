import 'package:flutter/material.dart';

class menu_show_one extends StatefulWidget {
  const menu_show_one({super.key});

  @override
  _show_menu createState() => _show_menu();
}

class _show_menu extends State<menu_show_one>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Text("Sample")
    );
  }
}