import 'dart:math';
import 'package:flutter/material.dart';
import '../../chat/presentation/chat_page.dart';
import '../data/plant_repository.dart';
import '../domain/plant_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PlantService _plantService;
  String currentQuote = "";
  final Random _random = Random();
  final GlobalKey _plantKey = GlobalKey(); // 🌱 식물 이미지 위치 추적용
  OverlayEntry? _heartOverlay; // ❤️ 현재 떠 있는 하트 추적

  @override
  void initState() {
    super.initState();
    _plantService = PlantService(PlantRepository());
    currentQuote = _plantService.getRandomQuote(); // 초기 문구 설정
  }

  /// ❤️ 하트 즉시 제거
  void _removeHeartImmediately() {
    if (_heartOverlay != null) {
      _heartOverlay!.remove();
      _heartOverlay = null;
    }
  }

  /// ❤️ 하트 애니메이션 (식물 이미지 내부 랜덤 위치)
  void _showHeartNearPlant() {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    // ✅ 기존 하트가 있으면 먼저 제거
    _removeHeartImmediately();

    // 👇 식물 이미지의 위치/크기 계산
    final renderBox =
        _plantKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    // 👇 랜덤 위치 (식물 내부)
    final double offsetX = _random.nextDouble() * size.width;
    final double offsetY = _random.nextDouble() * size.height;

    // ❤️ 새로운 하트 Overlay 생성
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
                child: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            );
          },
        ),
      ),
    );

    // Overlay 삽입
    overlay.insert(_heartOverlay!);

    // ⏳ 1초 후 자동 제거 (단, 즉시 제거되면 무시됨)
    Future.delayed(const Duration(seconds: 1), () {
      _removeHeartImmediately();
    });
  }

  /// 🌱 식물 버튼 → 랜덤 문구 + 하트 표시
  void _onPlantPressed() {
    setState(() {
      currentQuote = _plantService.getQuoteForPlant();
    });
    _showHeartNearPlant();
  }

  /// 💬 채팅 버튼 → 하트 제거 후 ChatPage 이동 (문구 변경 없음)
  void _onChatPressed() {
    _removeHeartImmediately(); // ✅ 떠 있는 하트 즉시 제거
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChatPage()),
    );
  }

  /// 📡 서버 이벤트 → 식물 버튼과 동일 동작
  void onServerMessageReceived() {
    _onPlantPressed();
  }

  @override
  Widget build(BuildContext context) {
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

              // 🌱 식물 이미지
              Center(
                child: GestureDetector(
                  key: _plantKey,
                  onTap: _onPlantPressed,
                  child: Image.asset(
                    'assets/images/plant_face.png',
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 🌱 랜덤 문구 출력
              Text(
                '“$currentQuote”',
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 16),

              // 💬 채팅 버튼
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

              // 📊 센서 카드
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
