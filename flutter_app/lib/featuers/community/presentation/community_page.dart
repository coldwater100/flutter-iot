import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color mainGreen = const Color(0xFF4CAF50);

    final posts = [
      {
        "image": "assets/images/plant_face.png",
        "title": "식물사랑꾼",
        "content": "우리집 몬스테라 새 잎 났어요! 너무 예쁘죠?\n#몬스테라 #식집사"
      },
      {
        "image": "assets/images/plant_face.png",
        "title": "초보 식집사",
        "content": "스투키 물주기 언제 하는 게 맞나요?\n#스투키 #도움"
      },
    ];

    final friends = [
      {"nickname": "플랜트러버"},
      {"nickname": "초록이"},
      {"nickname": "다육이매니아"},
    ];

    final guestbook = [
      "방문했어요~ 식물 너무 예뻐요 🌱",
      "화분이 잘 자라는 거 같아요! 👍",
      "언제 한번 물주기 꿀팁 공유해요 😀",
    ];

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
              Tab(text: "추천친구"),
              Tab(text: "친구"),
              Tab(text: "프로필"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // 1️⃣ 피드 탭
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return _buildPostCard(
                      imagePath: post["image"]!,
                      title: post["title"]!,
                      content: post["content"]!,
                      onVisit: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${post["title"]}님 페이지 방문")),
                        );
                      },
                      onAddFriend: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${post["title"]}님을 친구추가")),
                        );
                      },
                    );
                  },
                ),

                // 2️⃣ 친구 탭
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    final friend = friends[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(friend["nickname"]!),
                        trailing: TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("${friend["nickname"]}님 방문")),
                            );
                          },
                          child: const Text("방문"),
                        ),
                      ),
                    );
                  },
                ),

                // 3️⃣ 프로필 탭
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "자기소개",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "안녕하세요! 식물 키우는 걸 좋아하는 식집사입니다. 🌿",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "방명록",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ...guestbook.map((msg) => Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(msg),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 피드 카드 (게시글)
  Widget _buildPostCard({
    required String imagePath,
    required String title,
    required String content,
    required VoidCallback onVisit,
    required VoidCallback onAddFriend,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundImage: AssetImage(imagePath)),
                const SizedBox(width: 12),
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            Text(content),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: onVisit, child: const Text("방문")),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onAddFriend,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white),
                  child: const Text("친구추가"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
