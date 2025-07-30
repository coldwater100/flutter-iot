import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mainGreen = const Color(0xFF4CAF50);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          children: [
            const Text(
              '설정',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('알림'),
            SwitchListTile(
              title: const Text('푸시 알림 받기'),
              value: true,
              onChanged: (val) {},
              activeColor: mainGreen,
            ),
            const Divider(height: 32),
            _buildSectionTitle('계정'),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('계정 정보'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('비밀번호 변경'),
              onTap: () {},
            ),
            const Divider(height: 32),
            _buildSectionTitle('기타'),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('앱 정보'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('로그아웃'),
              onTap: () {
                // 추후 Navigator.pushReplacement 등으로 로그인 화면 이동 가능
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }
}
