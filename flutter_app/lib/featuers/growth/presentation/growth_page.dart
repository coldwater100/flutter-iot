import 'package:flutter/material.dart';

class GrowthPage extends StatelessWidget {
  const GrowthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color mainGreen = const Color(0xFF4CAF50);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 이미지 (영상 플레이어로 교체 가능)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset('assets/images/plant_video_thumbnail.png'),
          ),
          const SizedBox(height: 24),

          const Text(
            "성장 분석 리포트",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(Icons.show_chart, size: 64, color: Colors.green),
            ),
          ),
          const SizedBox(height: 12),

          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "AI 성장 예측: ",
                  style:
                      TextStyle(color: mainGreen, fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: "잎의 색이 더 선명해졌어요! 이 추세라면 2주 뒤 ",
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: "새잎이 돋아날 확률이 85%",
                  style:
                      TextStyle(color: mainGreen, fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: " 입니다.",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          const Text(
            "질병 및 진단 기록",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          GestureDetector(
            onTap: () {
              // 향후 상세 페이지 연결
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("2025-07-15: 흰가루병 의심"),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
