import 'package:flutter/material.dart';
import 'featuers/auth/presentation/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green Whisper',
      theme: ThemeData(fontFamily: 'Pretendard'), // 폰트 설정 가능
      home: LoginPage(),
    );
  }
}
