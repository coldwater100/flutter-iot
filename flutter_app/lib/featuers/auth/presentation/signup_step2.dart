import 'package:flutter/material.dart';
import '../domain/user_entity.dart';
import '../domain/qr_validator.dart'; // 👈 추가
import 'signup_step3.dart';
import '../../qr/presentation/qr_scanner_page.dart';

class SignupStep2Page extends StatefulWidget {
  final UserEntity user;

  const SignupStep2Page({super.key, required this.user});

  @override
  State<SignupStep2Page> createState() => _SignupStep2PageState();
}

class _SignupStep2PageState extends State<SignupStep2Page> {
  String? qrValue;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scanQR();
    });
  }

  Future<void> _scanQR() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QRScannerPage()),
    );

    if (!mounted) return;

    if (result != null && result is String) {
      setState(() {
        qrValue = result;
      });

      // ✅ QRValidator를 통해 형식 검증
      if (QRValidator.isValid(qrValue!)) {
        _next();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("잘못된 QR 코드입니다. 화분 고유 QR을 찍어주세요.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("QR 스캔이 취소되었습니다.")),
      );
    }
  }

  void _next() {
    final updatedUser = UserEntity(
      email: widget.user.email,
      password: widget.user.password,
      qrCode: qrValue,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => SignupStep3Page(user: updatedUser)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("회원가입 (2/3)")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Spacer(), // 상단 여백 확보 → 중앙보다 위로 배치됨

            // 👇 QR 다시 찍기 버튼
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 120,
                height: 120,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(), // 원형 버튼
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Colors.green,
                  ),
                  onPressed: _scanQR,
                  child: const Icon(
                    Icons.qr_code_scanner, // 👈 QR 아이콘
                    size: 64, // 아이콘 크기 크게
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30), // 버튼 아래 간격

            if (qrValue != null)
              Text(
                "스캔된 값: $qrValue",
                style: const TextStyle(color: Colors.green),
              ),

            const Spacer(flex: 2), // 하단 여백 → 버튼을 위쪽으로 올림
          ],
        ),
      ),
    );
  }
}
