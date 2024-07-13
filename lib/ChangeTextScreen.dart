import 'package:flutter/material.dart';
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';

class ChangeTextScreen extends StatefulWidget {
  final List<String> menu;

  const ChangeTextScreen({super.key, required this.menu});

  @override
  _RotatingTextScreenState createState() => _RotatingTextScreenState();
}

class _RotatingTextScreenState extends State<ChangeTextScreen>
    with SingleTickerProviderStateMixin {
  List<String> _texts = [];
  final List<FadeAnimatedText> lotate_text = [];

  @override
  void initState() {
    super.initState();
    _texts = widget.menu;
    for (int i = 0; i<_texts.length-1; i++) {
      lotate_text.add(FadeAnimatedText(_texts[i]));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        fontSize: 10.0,
        fontFamily: 'Horizon',
      ),
      child: AnimatedTextKit(
        pause: Duration(seconds: 0),
        animatedTexts: lotate_text,
        repeatForever: true,
        onTap: () {
          print("Tap Event");
        },
      ),
    );
  }
}
