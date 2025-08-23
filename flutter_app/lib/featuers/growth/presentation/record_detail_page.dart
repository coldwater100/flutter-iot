import 'package:flutter/material.dart';

class RecordDetailPage extends StatefulWidget {
  const RecordDetailPage({super.key});

  @override
  State<RecordDetailPage> createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends State<RecordDetailPage> {
  int _horizontalIndex = 0;
  int _verticalIndex = 0;

  final int maxHorizontal = 4; // 예시 날짜 수
  final int maxVertical = 4; // 예시 기록 종류 수

  final List<String> recordTypes = ["캐릭터", "식물 모습", "센서 기록", "메모"];

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity != null) {
      if (details.primaryVelocity! < 0 &&
          _horizontalIndex < maxHorizontal - 1) {
        setState(() => _horizontalIndex++);
      } else if (details.primaryVelocity! > 0 && _horizontalIndex > 0) {
        setState(() => _horizontalIndex--);
      }
    }
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity != null) {
      if (details.primaryVelocity! < 0 && _verticalIndex < maxVertical - 1) {
        setState(() => _verticalIndex++);
      } else if (details.primaryVelocity! > 0 && _verticalIndex > 0) {
        setState(() => _verticalIndex--);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color mainGreen = const Color(0xFF4CAF50);

    return Scaffold(
      appBar: AppBar(
        title: const Text("성장 기록 보기"),
        backgroundColor: mainGreen,
      ),
      body: GestureDetector(
        onHorizontalDragEnd: _onHorizontalDragEnd,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "날짜: 2025-07-${15 + _horizontalIndex}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "${recordTypes[_verticalIndex]} $_horizontalIndex",
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "↑↓ ${recordTypes[_verticalIndex]} 변경",
                style: const TextStyle(color: Colors.grey),
              ),
              const Text(
                "←→ 날짜 변경",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
