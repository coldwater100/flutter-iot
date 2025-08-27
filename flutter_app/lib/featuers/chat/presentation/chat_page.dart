import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();

  // 담백한 톤의 시나리오(식물 대사만)
  final List<String> plantScript = [
    "오늘 공기가 진짜 좋아~ 창가 햇살도 따뜻하고! 나는 잎이 반짝거리는 기분이야. 너는 오늘 기분 어때?",
    "오! 그렇구나~ 진짜 궁금하다. 뭐 때문에 그렇게 기분이 좋았어?",
    "헉, 맛있는 거 먹었구나! 나도 햇빛이랑 물만 먹어서 그런 거 진짜 부러워. 뭐 먹었는데?",
    "우와~ 소고기라니! 엄청 든든했겠다. 혹시 구워 먹었어? 아니면 다른 방법으로?"
  ];

  final List<String> userScript = [
    "나는 오늘 좀 행복해!",
    "좋은 일이 있었어. 시험도 잘 보고, 친구랑 놀았거든!",
    "오늘은 맛있는 소고기를 먹었어.",
    "응, 구워서 먹었어! 진짜 맛있었어!"
  ];

  int plantIndex = 0;
  bool _plantTyping = false;

  @override
  void initState() {
    super.initState();
    _messages.add({"role": "plant", "text": plantScript[plantIndex]});
    _jumpToBottom();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "text": text});
    });
    _controller.clear();
    _jumpToBottom();

    _schedulePlantReply();
  }

  Future<void> _schedulePlantReply() async {
    if (plantIndex + 1 >= plantScript.length) return;

    setState(() => _plantTyping = true);
    _jumpToBottom();

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() {
      _plantTyping = false;
      plantIndex++;
      _messages.add({"role": "plant", "text": plantScript[plantIndex]});
    });
    _jumpToBottom();
  }

  void _jumpToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _buildBubble({
    required bool isUser,
    required Widget child,
  }) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: const AssetImage('assets/plant_face/1.png'),
              backgroundColor: Colors.green.shade100,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? Colors.green.shade100 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ 애니메이션 타이핑 버블
  Widget _typingBubble() {
    return _buildBubble(
      isUser: false,
      child: const TypingDots(
        dotSize: 8,
        spacing: 6,
        duration: Duration(milliseconds: 900),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = _messages.length + (_plantTyping ? 1 : 0);

    return Scaffold(
      appBar: AppBar(title: const Text("식물과 대화하기")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(12),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                if (_plantTyping && index == _messages.length) {
                  return _typingBubble();
                }

                final msg = _messages[index];
                final isUser = msg["role"] == "user";
                return _buildBubble(
                  isUser: isUser,
                  child: Text(
                    msg["text"]!,
                    style: const TextStyle(fontSize: 15),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: const Border(top: BorderSide(color: Colors.grey)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "메시지를 입력하세요...",
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.green),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 깜빡이는 "..." 타이핑 표시 위젯 (외부 패키지 없이 구현)
class TypingDots extends StatefulWidget {
  const TypingDots({
    super.key,
    this.dotSize = 8,
    this.spacing = 6,
    this.duration = const Duration(milliseconds: 900),
    this.color,
  });

  final double dotSize;
  final double spacing;
  final Duration duration;
  final Color? color;

  @override
  State<TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // 3개의 점이 순차적으로 커졌다 작아지는 스케일 애니메이션
  late final Animation<double> _a1;
  late final Animation<double> _a2;
  late final Animation<double> _a3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();

    _a1 = CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.60, curve: Curves.easeInOut));
    _a2 = CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.20, 0.80, curve: Curves.easeInOut));
    _a3 = CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.40, 1.00, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _dot(Animation<double> anim) {
    final color = widget.color ?? Colors.grey.shade600;
    return ScaleTransition(
      scale: Tween(begin: 0.6, end: 1.0).animate(anim),
      child: Container(
        width: widget.dotSize,
        height: widget.dotSize,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _dot(_a1),
        SizedBox(width: widget.spacing),
        _dot(_a2),
        SizedBox(width: widget.spacing),
        _dot(_a3),
      ],
    );
  }
}
