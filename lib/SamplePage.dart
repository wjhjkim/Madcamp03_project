import 'package:flutter/material.dart';

class sample_page extends StatefulWidget {
  const sample_page({super.key});

  @override
  _show_menu createState() => _show_menu();
}

class _show_menu extends State<sample_page>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Sample")
    );
  }
}