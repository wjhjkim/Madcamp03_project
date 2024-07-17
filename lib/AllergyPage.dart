import 'package:flutter/material.dart';
import 'package:madcamp03/SamplePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'dart:convert';

class AllergyPage extends StatefulWidget {
  const AllergyPage({super.key});

  @override
  _AllergyManagementPageState createState() => _AllergyManagementPageState();
}

class _AllergyManagementPageState extends State<AllergyPage> {
  Map<String, bool> _allergies = {
    "난류": false,
    "우유": false,
    "메밀": false,
    "땅콩": false,
    "대두": false,
    "밀": false,
    "고등어": false,
    "게": false,
    "새우": false,
    "돼지고기": false,
    "복숭아": false,
    "토마토": false,
    "아황산류": false,
    "호두": false,
    "닭고기": false,
    "쇠고기": false,
    "오징어": false,
    "조개류": false,
    "잣": false,
  };

  @override
  void initState() {
    super.initState();
    _loadAllergies();
  }

  Future<void> _loadAllergies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? allergiesJson = prefs.getString('allergies');
    if (allergiesJson != null) {
      final Map<String, bool> loadedAllergies =
          Map<String, bool>.from(json.decode(allergiesJson));
      Future.delayed(Duration.zero, () {
        setState(() {
          _allergies = loadedAllergies;
        });
      });
    }
  }

  Future<void> _saveAllergies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String allergiesJson = json.encode(_allergies);
    await prefs.setString('allergies', allergiesJson);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('알레르기 정보가 저장되었습니다.')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알레르기 관리'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: _allergies.keys.map((String key) {
                  return CheckboxListTile(
                    title: Text(key),
                    value: _allergies[key],
                    onChanged: (bool? value) {
                      setState(() {
                        _allergies[key] = value ?? false;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: _saveAllergies,
              child: Text('저장하기'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48), // 버튼을 가로로 꽉 채우기
              ),
            ),
          ],
        ),
      ),
    );
  }
}
