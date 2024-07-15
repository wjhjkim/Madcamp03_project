import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MakeAccount extends StatefulWidget {
  const MakeAccount({super.key});

  @override
  _make_account createState() => _make_account();
}

class _make_account extends State<MakeAccount> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _IDController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // 여기에 회원가입 로직을 추가할 수 있습니다.
      final response = await http.post(
        Uri.parse('${dotenv.env['SERVER_URL']}/user/account'), // 여기에 실제 서버 URL을 입력하세요
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userID': _IDController.text,
          'userPW': _passwordController.text,
          'userName': _nameController.text
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입이 완료되었습니다.')),
        );
        Navigator.pop(context);
      } else {
        print('Failed: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입이 실패했습니다. 오류코드: ${response.statusCode}')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _IDController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

// new design
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: '이름',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이름을 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _IDController,
                decoration: InputDecoration(
                  labelText: '아이디',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.account_circle),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '아이디를 입력해주세요.';
                  } else if (value.length < 4) {
                    return '아이디는 최소 4자리여야 합니다.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해주세요.';
                  } else if (value.length < 6) {
                    return '비밀번호는 최소 6자리여야 합니다.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('회원가입', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.blue, // 버튼 배경색
                  foregroundColor: Colors.white, // 버튼 텍스트 색
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('회원가입'),
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Form(
  //         key: _formKey,
  //         child: ListView(
  //           children: [
  //             TextFormField(
  //               controller: _nameController,
  //               decoration: InputDecoration(
  //                 labelText: '이름',
  //                 border: OutlineInputBorder(),
  //               ),
  //               validator: (value) {
  //                 if (value == null || value.isEmpty) {
  //                   return '이름을 입력해주세요.';
  //                 }
  //                 return null;
  //               },
  //             ),
  //             SizedBox(height: 16),
  //             TextFormField(
  //               controller: _IDController,
  //               decoration: InputDecoration(
  //                 labelText: '아이디',
  //                 border: OutlineInputBorder(),
  //               ),
  //               validator: (value) {
  //                 if (value == null || value.isEmpty) {
  //                   return '아이디를 입력해주세요.';
  //                 } else if (value.length < 4) {
  //                   return '아이디는 최소 4자리여야 합니다.';
  //                 }
  //                 return null;
  //               },
  //             ),
  //             SizedBox(height: 16),
  //             TextFormField(
  //               controller: _passwordController,
  //               decoration: InputDecoration(
  //                 labelText: '비밀번호',
  //                 border: OutlineInputBorder(),
  //               ),
  //               obscureText: true,
  //               validator: (value) {
  //                 if (value == null || value.isEmpty) {
  //                   return '비밀번호를 입력해주세요.';
  //                 } else if (value.length < 6) {
  //                   return '비밀번호는 최소 6자리여야 합니다.';
  //                 }
  //                 return null;
  //               },
  //             ),
  //             SizedBox(height: 32),
  //             ElevatedButton(
  //               onPressed: _submitForm,
  //               child: Text('회원가입'),
  //               style: ElevatedButton.styleFrom(
  //                 minimumSize: Size(double.infinity, 48),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
