import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color mainGreen = const Color(0xFF4CAF50);

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            "커뮤니티",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TabBar(
            labelColor: mainGreen,
            unselectedLabelColor: Colors.grey,
            indicatorColor: mainGreen,
            tabs: const [
              Tab(text: "피드"),
              Tab(text: "우리 동네"),
              Tab(text: "미션"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // 피드 탭
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildPostCard(
                      imagePath: 'assets/images/plant_post1.png',
                      title: '식물사랑꾼',
                      content: '우리집 몬스테라 새 잎 났어요! 너무 예쁘죠?\n#몬스테라 #식집사',
                    ),
                    // 추후 더 추가 가능
                  ],
                ),

                // 우리 동네 탭
                const Center(child: Text("우리 동네 커뮤니티 기능 준비 중")),

                // 미션 탭
                const Center(child: Text("미션 기능 준비 중")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(
      {required String imagePath,
      required String title,
      required String content}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(imagePath),
            ),
            const SizedBox(height: 12),
            Text(content),
          ],
        ),
      ),
    );
  }
}
