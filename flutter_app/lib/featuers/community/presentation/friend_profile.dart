import 'package:flutter/material.dart';

class FriendProfilePage extends StatelessWidget {
  final String nickname;

  const FriendProfilePage({super.key, required this.nickname});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$nickname 님의 프로필")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: const AssetImage("assets/images/plant_face.png"),
            ),
            const SizedBox(height: 16),
            Text(
              nickname,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("안녕하세요! 저의 식물 공간에 방문해주셔서 감사합니다 🌱"),
            const SizedBox(height: 20),
            const Text(
              "방명록",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: const [
                  Card(
                      child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text("오늘도 잘 키우고 계시네요!"))),
                  Card(
                      child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text("화분 너무 예뻐요 🌿"))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
