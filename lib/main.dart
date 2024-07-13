import 'package:flutter/material.dart';
import 'tab2_todays_menu.dart';
import 'MakeAccount.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
  bool _showButtons = false;
  bool _startTextAnimation = false;

  @override
  void initState() {
    super.initState();

    _textController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _textAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -3),
    ).animate(
      CurvedAnimation(
        parent: _textController!,
        curve: Curves.easeInOut,
      ),
    );

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
                      tween: Tween<double>(begin: 60, end: 50),
                      duration: Duration(milliseconds: 500),
                      builder: (context, value, child) {
                        return Text(
                          '환영합니다',
                          style: TextStyle(
                              fontSize: value, fontWeight: FontWeight.bold),
                        );
                      },
                    )
                  : Text(
                      '환영합니다',
                      style:
                          TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
          if (_showButtons)
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        color: Colors.grey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: '사용자 이름',
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: '비밀번호',
                                ),
                                obscureText: true,
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => tab2_todays_menu()),
                                );
                              },
                              child: Text('로그인'),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 1.0,
                      width: 300.0,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        color: Colors.grey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MakeAccount()),
                                );
                              },
                              child: Text('회원가입'),
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
  }
}
