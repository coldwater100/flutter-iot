import 'dart:math';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  late final NetworkService _networkService;
  StreamSubscription<Event>? _eventSub;

  // 🌱 이미지 시퀀스 (총 36장)
  final List<String> plantImages = List.generate(
    36,
    (i) => 'assets/image_sequence/dir0_${i.toString().padLeft(2, '0')}.jpg',
  );

  // 🌱 표정 이미지 리스트
  final List<String> plantFaces = [
    'assets/plant_face/1.png',
    'assets/plant_face/2.png',
    'assets/plant_face/3.png',
  ];

  int _currentIndex = 0; // 👉 현재 표시 중인 시퀀스 인덱스
  int _faceIndex = 0; // 👉 표정 인덱스 (네트워크 이벤트로 갱신)

  bool _isHoldingLeft = false;
  bool _isHoldingRight = false;

  bool _isChatOpen = false;

  @override
  void initState() {
    super.initState();
    _plantService = PlantService(PlantRepository());
    currentQuote = _plantService.getRandomQuote();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _networkService = context.read<NetworkService>();

      _eventSub = _networkService.eventStream.listen((Event event) {
        print(
            "[HomePage] Event received: event=${event.event}, value=${event.value}, source=${event.source}");

        if (event.event == "plant_touch") {
          if (mounted) _onPlantPressed();
        }

        if (event.event == "plant_face") {
          final face = int.tryParse(event.value ?? '0') ?? 0;
          if (face >= 0 && face < plantFaces.length) {
            print("😀 얼굴 인덱스 업데이트: $face");
            setState(() {
              _faceIndex = face;
            });
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _eventSub?.cancel();
    _removeHeartImmediately();
    super.dispose();
  }

  void _removeHeartImmediately() {
    if (_heartOverlay != null) {
      _heartOverlay!.remove();
      _heartOverlay = null;
    }
  }

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
      if (mounted) _removeHeartImmediately();
    });
  }

  void _onPlantPressed() {
    setState(() {
      currentQuote = _plantService.getQuoteForPlant();
    });

    final msg =
        jsonEncode({"event": "plant_touch", "value": "", "source": "flutter"});
    _networkService.sendWSMessage(msg);
    print("📤 [HomePage] Sent to Jetson: $msg");

    if (!_isChatOpen) {
      _showHeartNearPlant();
    }
  }

  void _onChatPressed() {
    _removeHeartImmediately();
    _isChatOpen = true;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChatPage()),
    ).then((_) {
      _isChatOpen = false;
    });
  }

  Future<void> _animateToIndex(int targetIndex) async {
    int total = plantImages.length;
    int current = _currentIndex;

    int forwardSteps = (targetIndex - current + total) % total;
    int backwardSteps = (current - targetIndex + total) % total;

    bool goForward = forwardSteps <= backwardSteps;
    int steps = goForward ? forwardSteps : backwardSteps;

    for (int i = 1; i <= steps; i++) {
      await Future.delayed(const Duration(milliseconds: 60));
      if (!mounted) return;
      setState(() {
        if (goForward) {
          _currentIndex = (_currentIndex + 1) % total;
        } else {
          _currentIndex = (_currentIndex - 1 + total) % total;
        }
      });
    }
  }

  Future<void> _vibrateStrong() async {
    for (int i = 0; i < 3; i++) {
      HapticFeedback.vibrate();
      await Future.delayed(const Duration(milliseconds: 80));
    }
  }

  void _onLeftHoldStart() async {
    _isHoldingLeft = true;
    while (_isHoldingLeft && mounted) {
      setState(() {
        _currentIndex =
            (_currentIndex - 1 + plantImages.length) % plantImages.length;
      });
      for (int i = 0; i < 20; i++) {
        if (!_isHoldingLeft || !mounted) return;
        await Future.delayed(const Duration(milliseconds: 10));
      }
    }
  }

  void _onRightHoldStart() async {
    _isHoldingRight = true;
    while (_isHoldingRight && mounted) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % plantImages.length;
      });
      for (int i = 0; i < 20; i++) {
        if (!_isHoldingRight || !mounted) return;
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
                'Green Whisper',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final imageWidth = constraints.maxWidth * 0.6;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                                  children:
                                      List.generate(plantImages.length, (i) {
                                    if (i == 0) {
                                      // 👉 시작 또는 웃는 버튼 눌러서 0번일 때는 plant_face, 아니면 시퀀스 0번
                                      if (_currentIndex == 0) {
                                        return Image.asset(
                                          plantFaces[_faceIndex],
                                          fit: BoxFit.contain,
                                        );
                                      } else {
                                        return Image.asset(
                                          plantImages[0],
                                          fit: BoxFit.contain,
                                        );
                                      }
                                    } else {
                                      return Image.asset(
                                        plantImages[i],
                                        fit: BoxFit.contain,
                                      );
                                    }
                                  }),
                                ),
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
