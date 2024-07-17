import 'package:flutter/material.dart';
import 'tab2_todays_menu.dart';
import 'MakeAccount.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'util.dart';
import 'theme.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(
      ChangeNotifierProvider(create: (context) => Allergy(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Nanum Gothic Coding", "IBM Plex Sans KR");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'login page',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController? _textController;
  Animation<Offset>? _textAnimation;
  final TextEditingController _IDcontroller = TextEditingController();
  final TextEditingController _PWcontroller = TextEditingController();
  bool _showButtons = false;
  bool _startTextAnimation = false;
  String jwtToken = '';

  Future<void> _sendData() async {
    final String id = _IDcontroller.text;
    final String pw = _PWcontroller.text;

    final response = await http.post(
      Uri.parse('${dotenv.env['SERVER_URL']}/user/login'), // 여기에 실제 서버 URL을 입력하세요
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userID': id,
        'userPW': pw,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        jwtToken = responseData['jwtToken'];
      });
      await _saveTokenAndID(jwtToken, id);
      print('Token saved: $jwtToken');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                tab2_todays_menu()),
      );
    } else {
      print('Failed: ${response.statusCode} ${response.reasonPhrase}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인이 실패했습니다. 오류코드: ${response.statusCode} ${response.reasonPhrase}')),
      );
    }
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      jwtToken = prefs.getString('jwtToken') ?? '';
    });
    if (jwtToken.isNotEmpty) {
      _verifyToken(jwtToken);
    }
  }

  Future<void> _saveTokenAndID(String token, String ID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('jwtToken', token);
    prefs.setString('userID', ID);
  }

  Future<void> _verifyToken(String token) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['SERVER_URL']}/user/jwt'), // 실제 서버 URL을 입력하세요
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'jwtToken': token,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                tab2_todays_menu()),
      );
    } else {
      print('Token verification failed: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  @override
  void initState() {
    super.initState();

    _textController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _textAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -4),
    ).animate(
      CurvedAnimation(
        parent: _textController!,
        curve: Curves.easeInOut,
      ),
    );

    _loadToken();

    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(Duration(milliseconds: 700));
    setState(() {
      _startTextAnimation = true;
    });
    _textController?.forward();
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _showButtons = true;
    });
  }

  @override
  void dispose() {
    _textController?.dispose();
    super.dispose();
    _IDcontroller.dispose();
    _PWcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: SlideTransition(
              position: _textAnimation!,
              child: _startTextAnimation
                  ? TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 40, end: 34),
                duration: Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return Text(
                    '넙죽아 죽이 짜다',
                    style: TextStyle(
                        fontSize: value, fontWeight: FontWeight.bold),
                  );
                },
              )
                  : Text(
                '넙죽아 죽이 짜다',
                style:
                TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (_showButtons)
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.only(top: 100.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 10),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextField(
                                controller: _IDcontroller,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: '사용자 ID',
                                  prefixIcon: Icon(Icons.person),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextField(
                                controller: _PWcontroller,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: '비밀번호',
                                  prefixIcon: Icon(Icons.lock),
                                ),
                                obscureText: true,
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                _sendData();
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => tab2_todays_menu()), // 다음 페이지로 이동
                                // );
                              },
                              child: Text('로그인', style: TextStyle(fontWeight: FontWeight.w800),),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                minimumSize: Size(double.infinity, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              // style: ElevatedButton.styleFrom(
                              //   minimumSize: Size(double.infinity, 48),
                              //   shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(10),
                              //   ),
                              //   backgroundColor: Colors.blue, // 버튼 배경색
                              //   foregroundColor: Colors.white, // 버튼 텍스트 색
                              // ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 1.0,
                      width: 300.0,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MakeAccount()), // 회원가입 페이지로 이동
                                );
                              },
                              child: Text('회원가입', style: TextStyle(fontWeight: FontWeight.w800),),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                minimumSize: Size(double.infinity, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              // style: ElevatedButton.styleFrom(
                              //   minimumSize: Size(double.infinity, 48),
                              //   shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(10),
                              //   ),
                              //   backgroundColor: Colors.green, // 버튼 배경색
                              //   foregroundColor: Colors.white, // 버튼 텍스트 색
                              // ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     body: Stack(
  //       children: [
  //         Center(
  //           child: SlideTransition(
  //             position: _textAnimation!,
  //             child: _startTextAnimation
  //                 ? TweenAnimationBuilder<double>(
  //                     tween: Tween<double>(begin: 60, end: 50),
  //                     duration: Duration(milliseconds: 500),
  //                     builder: (context, value, child) {
  //                       return Text(
  //                         '환영합니다',
  //                         style: TextStyle(
  //                             fontSize: value, fontWeight: FontWeight.bold),
  //                       );
  //                     },
  //                   )
  //                 : Text(
  //                     '환영합니다',
  //                     style:
  //                         TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
  //                   ),
  //           ),
  //         ),
  //         if (_showButtons)
  //           Align(
  //             alignment: Alignment.center,
  //             child: Container(
  //               padding: const EdgeInsets.only(top: 50.0),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //                     child: Container(
  //                       color: Colors.grey,
  //                       child: Column(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           SizedBox(height: 10),
  //                           Padding(
  //                             padding:
  //                                 const EdgeInsets.symmetric(horizontal: 20.0),
  //                             child: TextField(
  //                               controller: _IDcontroller,
  //                               decoration: InputDecoration(
  //                                 border: OutlineInputBorder(),
  //                                 labelText: '사용자 ID',
  //                               ),
  //                             ),
  //                           ),
  //                           SizedBox(height: 10),
  //                           Padding(
  //                             padding:
  //                                 const EdgeInsets.symmetric(horizontal: 20.0),
  //                             child: TextField(
  //                               controller: _PWcontroller,
  //                               decoration: InputDecoration(
  //                                 border: OutlineInputBorder(),
  //                                 labelText: '비밀번호',
  //                               ),
  //                               obscureText: true,
  //                             ),
  //                           ),
  //                           SizedBox(height: 10),
  //                           ElevatedButton(
  //                             onPressed: () {
  //                               // _sendData();
  //                               Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                     builder: (context) => tab2_todays_menu()),
  //                               );
  //                             },
  //                             child: Text('로그인'),
  //                           ),
  //                           SizedBox(height: 10),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(height: 10),
  //                   Container(
  //                     height: 1.0,
  //                     width: 300.0,
  //                     color: Colors.grey,
  //                   ),
  //                   SizedBox(height: 10),
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //                     child: Container(
  //                       color: Colors.grey,
  //                       child: Column(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           SizedBox(height: 10),
  //                           ElevatedButton(
  //                             onPressed: () {
  //                               Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                     builder: (context) => MakeAccount()),
  //                               );
  //                             },
  //                             child: Text('회원가입'),
  //                           ),
  //                           SizedBox(height: 10),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  }
}

class Allergy extends ChangeNotifier {
  Map<String, bool> _allergies = {
    '난류': false,
    '우유': false,
    '메밀': false,
    '땅콩': false,
    '대두': false,
    '밀': false,
    '고등어': false,
    '게': false,
    '새우': false,
    '돼지고기': false,
    '복숭아': false,
    '토마토': false,
    '아황산류': false,
    '호두': false,
    '닭고기': false,
    '쇠고기': false,
    '오징어': false,
    '조개류 (굴, 전복, 홍합 포함)': false,
    '잣': false,
  };

  Map<String, bool> get allergies => _allergies;

  void allergie_set(String name, bool value) {
    _allergies[name] = value;
    notifyListeners();
  }

  void saveAllergies(Map<String, bool> allergies) {
    _allergies = allergies;
    notifyListeners();
  }
}
