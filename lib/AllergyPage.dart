import 'package:flutter/material.dart';
import 'package:madcamp03/SamplePage.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class AllergyPage extends StatefulWidget {
  const AllergyPage({super.key});

  @override
  _AllergyManagementPageState createState() => _AllergyManagementPageState();
}

class _AllergyManagementPageState extends State<AllergyPage> {
  Map<String, bool> _allergies = {  };

  void _saveAllergies() {
    // 여기에 알레르기 정보를 저장하는 로직을 추가할 수 있습니다.
    final allergies = Provider.of<Allergy>(context, listen: false);
    allergies.saveAllergies(_allergies);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('알레르기 정보가 저장되었습니다.')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final allergies = Provider.of<Allergy>(context);
    _allergies = allergies.allergies;

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