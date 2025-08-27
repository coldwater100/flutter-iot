import 'package:flutter/material.dart';
import 'record_detail_page.dart';
import '../../disease/domain/disease_entity.dart';
import '../../disease/presentation/disease_detail_page.dart';

class GrowthPage extends StatelessWidget {
  const GrowthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color mainGreen = const Color(0xFF4CAF50);

    // 예시 데이터 (추후 Repository 연동 가능)
    final List<DiseaseEntity> diseaseRecords = [
      DiseaseEntity(
        id: "1",
        date: "2025-07-15",
        title: "흰가루병 의심",
        description: "잎에 하얀 가루가 번짐. 곰팡이 초기 감염 가능성.",
        imagePath: "assets/images/disease1.png",
      ),
      DiseaseEntity(
        id: "2",
        date: "2025-08-01",
        title: "잎마름병 의심",
        description: "잎 끝이 갈변하며 마름. 세균성 질환 가능성.",
        imagePath: "assets/images/disease2.png",
      ),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24), // 👈 상단 여백 추가
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(16),
            //   child: Image.asset(
            //     'assets/images/KakaoTalk_20250822_171512122_13.png',
            //   ),
            // ),
            // const SizedBox(height: 24),

            const Text(
              "성장 분석 리포트",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // 📌 성장 리포트 차트 + 버튼
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child:
                        Icon(Icons.show_chart, size: 64, color: Colors.green),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.calendar_month,
                        color: Colors.green, size: 28),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RecordDetailPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "AI 성장 예측: ",
                    style: TextStyle(
                        color: mainGreen, fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text: "잎의 색이 더 선명해졌어요! 이 추세라면 2주 뒤 ",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: "새잎이 돋아날 확률이 85%",
                    style: TextStyle(
                        color: mainGreen, fontWeight: FontWeight.bold),
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

            // 📌 질병 리스트
            Column(
              children: diseaseRecords.map((record) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DiseaseDetailPage(record: record),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${record.date}: ${record.title}"),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
