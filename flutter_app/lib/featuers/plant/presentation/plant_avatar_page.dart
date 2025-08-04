// ✅ presentation: 아바타 생성 페이지
// File: features/plants/presentation/plant_avatar_page.dart
import 'package:flutter/material.dart';

class PlantAvatarPage extends StatelessWidget {
  const PlantAvatarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('아바타 생성')),
      body: const Center(
        child: Text('아바타 생성 페이지 (추후 구현)'),
      ),
    );
  }
}
