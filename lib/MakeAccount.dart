import 'package:flutter/material.dart';

class MakeAccount extends StatefulWidget {
  const MakeAccount({super.key});

  @override
  _make_account createState() => _make_account();
}

class _make_account extends State<MakeAccount>
    with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Text("Make account")
    );
  }
}