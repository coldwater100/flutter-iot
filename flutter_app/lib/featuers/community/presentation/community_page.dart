import 'package:flutter/material.dart';
import 'friend_profile.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
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
    "방문했어요~ 식물 너무 예뻐요",
    "화분이 잘 자라는 거 같아요!",
    "언제 한번 물주기 꿀팁 공유해요",
  ];

  // ✅ 자기소개 상태
  String introduction = "안녕하세요! 식물 키우는 걸 좋아하는 식집사입니다.";
  bool isEditingIntro = false;
  final TextEditingController _introController = TextEditingController();

  final hashtags = ["#몬스테라", "#스투키", "#다육이", "#초보식집사", "#플랜트러버"];
  final Set<String> selectedTags = {};

  @override
  void initState() {
    super.initState();
    _introController.text = introduction;
  }

  @override
  void dispose() {
    // ✅ 컨트롤러 메모리 해제
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const SizedBox(height: 44), // 👈 상단 여백 추가
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
                // 1️⃣ 추천친구 탭
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return PostCard(
                      imagePath: post["image"]!,
                      title: post["title"]!,
                      content: post["content"]!,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FriendProfilePage(
                                    nickname: friend["nickname"]!),
                              ),
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
                      Row(
                        children: [
                          const Text(
                            "자기소개",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isEditingIntro = !isEditingIntro;
                                if (isEditingIntro) {
                                  _introController.text = introduction;
                                }
                              });
                            },
                            child: const Icon(Icons.edit),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // ✅ 보기 모드 / 수정 모드
                      if (!isEditingIntro) ...[
                        Text(
                          introduction +
                              (selectedTags.isNotEmpty
                                  ? "\n${selectedTags.join(" ")}"
                                  : ""),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ] else ...[
                        TextField(
                          controller: _introController,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            hintText: "자기소개를 입력하세요...",
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              introduction = _introController.text.trim();
                              isEditingIntro = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: mainGreen,
                              foregroundColor: Colors.white),
                          child: const Text("저장"),
                        ),
                      ],

                      const SizedBox(height: 12),
                      // ✅ 해시태그는 항상 노출
                      Wrap(
                        spacing: 8,
                        children: hashtags.map((tag) {
                          final isSelected = selectedTags.contains(tag);
                          return FilterChip(
                            label: Text(tag),
                            selected: isSelected,
                            selectedColor: mainGreen.withOpacity(0.2),
                            checkmarkColor: mainGreen,
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  selectedTags.add(tag);
                                  if (!_introController.text.contains(tag)) {
                                    _introController.text =
                                        "${_introController.text} $tag";
                                  }
                                } else {
                                  selectedTags.remove(tag);
                                  _introController.text = _introController.text
                                      .replaceAll(tag, "")
                                      .trim();
                                }
                                // 저장된 자기소개에도 즉시 반영
                              });
                            },
                          );
                        }).toList(),
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
}

/// ✅ 독립 카드 위젯 (좋아요/싫어요 토글)
class PostCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String content;

  const PostCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.content,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;
  bool isDisliked = false;

  @override
  Widget build(BuildContext context) {
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
                CircleAvatar(backgroundImage: AssetImage(widget.imagePath)),
                const SizedBox(width: 12),
                Text(widget.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            Text(widget.content),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            FriendProfilePage(nickname: widget.title),
                      ),
                    );
                  },
                  child: const Text("방문"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    debugPrint("${widget.title}님을 친구추가");
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white),
                  child: const Text("친구추가"),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.thumb_up,
                    color: Colors.blue.withOpacity(isLiked ? 1.0 : 0.3),
                  ),
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                      if (isLiked) isDisliked = false;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.thumb_down,
                    color: Colors.red.withOpacity(isDisliked ? 1.0 : 0.3),
                  ),
                  onPressed: () {
                    setState(() {
                      isDisliked = !isDisliked;
                      if (isDisliked) isLiked = false;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
