import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ 햅틱
import 'package:provider/provider.dart';

import '../../chat/presentation/chat_page.dart';
import '../data/plant_repository.dart';
import '../domain/plant_service.dart';
import '../../network/domain/network_service.dart';
import '../../network/domain/event.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PlantService _plantService;
  String currentQuote = "";
  final Random _random = Random();
  final GlobalKey _plantKey = GlobalKey();
  OverlayEntry? _heartOverlay;

  bool _isRotateMode = false;
  double _startDx = 0;
  int _startIndex = 0;

  // ✅ 네트워크 서비스
  late final NetworkService _networkService;

  // 🌱 이미지 시퀀스 (1~50)
  final List<String> plantImages = List.generate(
    50,
    (i) => 'assets/image_sequence/plant_${i + 1}.png',
  );

  int _currentIndex = 0; // 👉 시작: plant_1.png

  // 버튼 홀드 상태 플래그
  bool _isHoldingLeft = false;
  bool _isHoldingRight = false;

  // ✅ ChatPage 열림 여부 플래그
  bool _isChatOpen = false;

  @override
  void initState() {
    super.initState();
    _plantService = PlantService(PlantRepository());
    currentQuote = _plantService.getRandomQuote();

    // ✅ 네트워크 서비스 가져오기 (context 사용은 frame 이후 안전)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _networkService = context.read<NetworkService>();

      // ✅ 이벤트 구독
      _networkService.eventStream.listen((Event event) {
        print(
            "🎯 [HomePage] Event received: type=${event.type}, action=${event.action}");

        if (event.type == "event" && event.action == "plant_pressed") {
          if (mounted) _onPlantPressed();
        }
      });
    });
  }

  /// ❤️ 하트 즉시 제거
  void _removeHeartImmediately() {
    if (_heartOverlay != null) {
      _heartOverlay!.remove();
      _heartOverlay = null;
    }
  }

  /// ❤️ 하트 애니메이션
  void _showHeartNearPlant() {
    final overlay = Overlay.of(context);
    if (overlay == null) return;
    _removeHeartImmediately();

    final renderBox =
        _plantKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    final double offsetX = _random.nextDouble() * size.width;
    final double offsetY = _random.nextDouble() * size.height;

    _heartOverlay = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx + offsetX - 20,
        top: position.dy + offsetY - 20,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: Transform.scale(
                scale: value,
                child: const Icon(Icons.favorite, color: Colors.red, size: 40),
              ),
            );
          },
        ),
      ),
    );

    overlay.insert(_heartOverlay!);

    Future.delayed(const Duration(seconds: 1), () {
      _removeHeartImmediately();
    });
  }

  /// 🌱 식물 버튼 → 랜덤 문구 + 하트 + Jetson 이벤트 전송
  void _onPlantPressed() {
    setState(() {
      currentQuote = _plantService.getQuoteForPlant();
    });

    // ✅ Jetson으로 이벤트 전송
    final msg = jsonEncode(
        {"type": "event", "action": "plant_pressed", "source": "flutter"});
    _networkService.sendWSMessage(msg);
    print("📤 [HomePage] Sent to Jetson: $msg");

    // ✅ ChatPage가 열려있지 않을 때만 하트 표시
    if (!_isChatOpen) {
      _showHeartNearPlant();
    }
  }

  /// 💬 채팅 버튼
  void _onChatPressed() {
    _removeHeartImmediately();
    _isChatOpen = true; // ✅ 채팅화면 열림
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChatPage()),
    ).then((_) {
      // ✅ 닫히면 다시 false
      _isChatOpen = false;
    });
  }

  /// 😀 웃는 버튼 → plant_1.png 로 이동
  Future<void> _animateToIndex(int targetIndex) async {
    int total = plantImages.length;
    int current = _currentIndex;

    int forwardSteps = (targetIndex - current + total) % total;
    int backwardSteps = (current - targetIndex + total) % total;

    bool goForward = forwardSteps <= backwardSteps;
    int steps = goForward ? forwardSteps : backwardSteps;

    for (int i = 1; i <= steps; i++) {
      await Future.delayed(const Duration(milliseconds: 60));
      setState(() {
        if (goForward) {
          _currentIndex = (_currentIndex + 1) % total;
        } else {
          _currentIndex = (_currentIndex - 1 + total) % total;
        }
      });
    }
  }

  /// ✅ 강한 햅틱
  Future<void> _vibrateStrong() async {
    for (int i = 0; i < 3; i++) {
      HapticFeedback.vibrate();
      await Future.delayed(const Duration(milliseconds: 80));
    }
  }

  /// ⬅️ 왼쪽 버튼 롱클릭 동작
  void _onLeftHoldStart() async {
    _isHoldingLeft = true;
    while (_isHoldingLeft) {
      setState(() {
        _currentIndex =
            (_currentIndex - 1 + plantImages.length) % plantImages.length;
      });
      for (int i = 0; i < 20; i++) {
        if (!_isHoldingLeft) return;
        await Future.delayed(const Duration(milliseconds: 10));
      }
    }
  }

  /// ➡️ 오른쪽 버튼 롱클릭 동작
  void _onRightHoldStart() async {
    _isHoldingRight = true;
    while (_isHoldingRight) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % plantImages.length;
      });
      for (int i = 0; i < 20; i++) {
        if (!_isHoldingRight) return;
        await Future.delayed(const Duration(milliseconds: 10));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                'GREEN WHISPER',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),

              // 🌱 이미지 + 좌우 버튼 + 웃는 버튼
              Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final imageWidth = constraints.maxWidth * 0.6;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // ⬅️ 왼쪽 버튼
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentIndex =
                                  (_currentIndex - 1 + plantImages.length) %
                                      plantImages.length;
                            });
                          },
                          onLongPressStart: (_) {
                            _vibrateStrong();
                            _onLeftHoldStart();
                          },
                          onLongPressEnd: (_) {
                            _isHoldingLeft = false;
                          },
                          child: const Icon(Icons.arrow_left,
                              size: 40, color: Colors.black54),
                        ),

                        const SizedBox(width: 12),

                        // 🌱 식물 이미지
                        GestureDetector(
                          key: _plantKey,
                          onTap: _onPlantPressed,
                          onLongPressStart: (details) {
                            setState(() {
                              _isRotateMode = true;
                              _startDx = details.globalPosition.dx;
                              _startIndex = _currentIndex;
                            });
                            _vibrateStrong();
                          },
                          onLongPressMoveUpdate: (details) {
                            if (!_isRotateMode) return;
                            double diffX = details.globalPosition.dx - _startDx;
                            double ratio = diffX / screenWidth;
                            int moveFrames =
                                (ratio * plantImages.length).round();
                            int newIndex =
                                (_startIndex + moveFrames) % plantImages.length;
                            if (newIndex < 0) newIndex += plantImages.length;
                            setState(() {
                              _currentIndex = newIndex;
                            });
                          },
                          onLongPressEnd: (_) {
                            setState(() {
                              _isRotateMode = false;
                            });
                          },
                          child: SizedBox(
                            width: imageWidth,
                            child: Stack(
                              children: [
                                IndexedStack(
                                  index: _currentIndex,
                                  children: plantImages
                                      .map((path) => Image.asset(path,
                                          fit: BoxFit.contain))
                                      .toList(),
                                ),
                                // 😀 웃는 버튼
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: IconButton(
                                    icon: const Icon(
                                        Icons.sentiment_very_satisfied,
                                        color: Colors.green,
                                        size: 32),
                                    onPressed: () {
                                      _animateToIndex(0);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // ➡️ 오른쪽 버튼
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentIndex =
                                  (_currentIndex + 1) % plantImages.length;
                            });
                          },
                          onLongPressStart: (_) {
                            _vibrateStrong();
                            _onRightHoldStart();
                          },
                          onLongPressEnd: (_) {
                            _isHoldingRight = false;
                          },
                          child: const Icon(Icons.arrow_right,
                              size: 40, color: Colors.black54),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
              Text(
                '“$currentQuote”',
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 16),

              IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: Image.asset(
                  'assets/icons/chat_icon.png',
                  width: 36,
                  height: 36,
                ),
                onPressed: _onChatPressed,
              ),

              const SizedBox(height: 32),

              // 📊 센서 카드들
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildSensorCard(
                        'assets/icons/thermometer.png', '온도', '25℃'),
                    _buildSensorCard('assets/icons/soil.png', '토양 습도', '68%'),
                    _buildSensorCard('assets/icons/sun.png', '조도', '950 Lux'),
                    _buildSensorCard(
                        'assets/icons/humidity.png', '공기 습도', '60%'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// 📊 센서 카드 빌더
  Widget _buildSensorCard(String iconPath, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, width: 32, height: 32),
          const SizedBox(height: 12),
          Text(label,
              style: const TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
