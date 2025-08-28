import 'package:flutter/material.dart';
import '../../plant/domain/analyze_plant_usecase.dart';
import '../../plant/domain/generate_character_usecase.dart';
import '../../plant/data/plant_repository_impl.dart';
import '../../plant/data/plant_remote_source.dart';
import '../domain/user_entity.dart';

enum SignupProcessState {
  analyzingPlant,
  generatingCharacter,
  done,
}

class SignupStep3Page extends StatefulWidget {
  final UserEntity user;
  const SignupStep3Page({super.key, required this.user});

  @override
  State<SignupStep3Page> createState() => _SignupStep3PageState();
}

class _SignupStep3PageState extends State<SignupStep3Page> {
  late final AnalyzePlantUsecase _analyzePlantUsecase;
  late final GenerateCharacterUsecase _generateCharacterUsecase;

  SignupProcessState _state = SignupProcessState.analyzingPlant;

  String? _plantType;
  double? _accuracy;
  String? _description;
  String? _characterPath;

  @override
  void initState() {
    super.initState();
    final repo = PlantRepositoryImpl(PlantRemoteSource());
    _analyzePlantUsecase = AnalyzePlantUsecase(repo);
    _generateCharacterUsecase = GenerateCharacterUsecase(repo);

    _startProcess();
  }

  Future<void> _startProcess() async {
    // 1단계: 식물 분석
    final plantResult = await _analyzePlantUsecase.execute(widget.user.email);
    setState(() {
      _plantType = plantResult.plantType;
      _accuracy = plantResult.accuracy;
      _description = plantResult.description;
      _state = SignupProcessState.generatingCharacter;
    });

    // 2단계: 캐릭터 생성
    final charPath =
        await _generateCharacterUsecase.execute(plantResult.plantType);
    setState(() {
      _characterPath = charPath;
      _state = SignupProcessState.done;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color mainGreen = const Color(0xFF4CAF50);

    return Scaffold(
      appBar: AppBar(title: const Text("회원가입 (3/3)")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_state == SignupProcessState.analyzingPlant)
              _buildLoading("식물 촬영 중..."),
            if (_state == SignupProcessState.generatingCharacter)
              _buildLoading("캐릭터 생성 중..."),
            if (_state == SignupProcessState.done) ...[
              _buildPlantResult(),
              const SizedBox(height: 24),
              _buildCharacter(),
            ],
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16), // 👈 하단 여백 추가
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: mainGreen),
              onPressed: (_state == SignupProcessState.done)
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("회원가입 완료!")),
                      );
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                  : null,
              child: const Text("회원가입 완료"),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading(String message) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text(message, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      );

  Widget _buildPlantResult() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("예측 결과", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("식물 종류: $_plantType",
                style: const TextStyle(color: Colors.green)),
            Text("정확도: ${(_accuracy! * 100).toStringAsFixed(0)}%",
                style: const TextStyle(color: Colors.green)),
            Text("특징: $_description"),
          ],
        ),
      );

  Widget _buildCharacter() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            const Text("생성된 캐릭터"),
            const SizedBox(height: 8),
            ClipOval(
              child: Image.asset(
                _characterPath ?? "assets/plant_face/2.png",
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "\"안녕! 나는 너의 $_plantType 친구야! 오늘도 싱그러운 하루 보내자!\"",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
}
