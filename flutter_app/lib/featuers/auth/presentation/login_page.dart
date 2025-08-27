import 'package:flutter/material.dart';
import '../../main/presentation/main_page.dart';
import 'signup_step1.dart';
import '../domain/login_usecase.dart';
import '../data/auth_repository_impl.dart';
import '../data/auth_remote_source.dart';
import '../../qr/presentation/qr_scanner_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _loginUsecase = LoginUsecase(AuthRepositoryImpl(AuthRemoteSource()));

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final success = await _loginUsecase.execute(email, password);

    if (!mounted) return; // 👈 위젯이 살아있는지 확인

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("로그인 실패")),
      );
    }
  }

  Future<void> _loginWithQr() async {
    final qrValue = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QRScannerPage()),
    );

    if (!mounted) return; // 👈 위젯이 살아있는지 확인

    if (qrValue != null) {
      final success = await _loginUsecase.qrExecute(qrValue);

      if (!mounted) return; // 👈 추가

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("QR 로그인 실패")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color mainGreen = const Color(0xFF4CAF50);

    return Scaffold(
      resizeToAvoidBottomInset: true, // 키보드 올라올 때 화면 자동 조정
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          // 👈 overflow 방지
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 64),
              Text(
                "Green Whisper",
                style: TextStyle(
                  color: mainGreen,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),

              // 이메일 입력
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: '이메일 입력',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // 비밀번호 입력
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: '비밀번호 입력',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),

              // 로그인 버튼
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainGreen,
                  ),
                  child: const Text("로그인"),
                ),
              ),
              const SizedBox(height: 12),

              // QR 로그인 버튼
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: _loginWithQr,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: mainGreen),
                  ),
                  child: Text("QR 로그인", style: TextStyle(color: mainGreen)),
                ),
              ),
              const SizedBox(height: 20),

              // 회원가입 버튼
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupStep1Page()),
                  );
                },
                child: Text("회원가입", style: TextStyle(color: mainGreen)),
              ),

              const SizedBox(height: 64), // 👈 하단 여유 공간
            ],
          ),
        ),
      ),
    );
  }
}
