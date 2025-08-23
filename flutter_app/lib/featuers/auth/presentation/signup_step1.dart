import 'package:flutter/material.dart';
import '../domain/user_entity.dart';
import 'signup_step2.dart';

class SignupStep1Page extends StatefulWidget {
  const SignupStep1Page({super.key});

  @override
  State<SignupStep1Page> createState() => _SignupStep1PageState();
}

class _SignupStep1PageState extends State<SignupStep1Page> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  void _next() {
    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("비밀번호가 일치하지 않습니다")));
      return;
    }

    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      final user = UserEntity(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SignupStep2Page(user: user)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("회원가입 (1/3)")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "이메일")),
            TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "비밀번호")),
            TextField(
                controller: _confirmController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "비밀번호 확인")),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _next, child: const Text("다음")),
          ],
        ),
      ),
    );
  }
}
