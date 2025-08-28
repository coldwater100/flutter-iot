import 'package:flutter/material.dart';
import 'featuers/auth/presentation/login_page.dart';
import 'package:provider/provider.dart';
import 'app_providers.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ 앱 시작 시 카메라 권한 요청
  final status = await Permission.camera.request();
  if (!status.isGranted) {
    debugPrint("카메라 권한이 거부되었습니다. 일부 기능이 제한될 수 있습니다.");
  }

  runApp(
    MultiProvider(
      providers: globalProviders,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green Whisper',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: Colors.white, // ✅ 기본 배경색 흰색으로 설정
      ),
      home: const LoginPage(),
    );
  }
}
