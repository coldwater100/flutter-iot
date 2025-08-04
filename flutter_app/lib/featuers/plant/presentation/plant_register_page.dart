// ✅ presentation: 식물 등록 페이지
// File: features/plants/presentation/plant_register_page.dart
import 'package:flutter/material.dart';
import 'plant_avatar_page.dart';

class PlantRegisterPage extends StatelessWidget {
  const PlantRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final plantNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('식물 등록')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('당신의 식물 이름을 입력하세요:'),
            const SizedBox(height: 12),
            TextField(
              controller: plantNameController,
              decoration: const InputDecoration(hintText: '예: 몬스테라'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PlantAvatarPage()),
                );
              },
              child: const Text('다음'),
            )
          ],
        ),
      ),
    );
  }
}
