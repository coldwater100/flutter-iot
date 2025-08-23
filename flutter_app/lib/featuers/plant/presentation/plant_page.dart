import 'package:flutter/material.dart';
import '../domain/analyze_plant_usecase.dart';
import '../domain/generate_character_usecase.dart';
import '../data/plant_repository_impl.dart';
import '../data/plant_remote_source.dart';

class PlantPage extends StatefulWidget {
  const PlantPage({super.key});

  @override
  State<PlantPage> createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  late final AnalyzePlantUsecase _analyzePlantUsecase;
  late final GenerateCharacterUsecase _generateCharacterUsecase;

  bool _loadingPlant = true;
  bool _loadingCharacter = true;
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
    final plantResult = await _analyzePlantUsecase.execute("user123");
    setState(() {
      _loadingPlant = false;
      _plantType = plantResult.plantType;
      _accuracy = plantResult.accuracy;
      _description = plantResult.description;
    });

    final charPath =
        await _generateCharacterUsecase.execute(plantResult.plantType);
    setState(() {
      _loadingCharacter = false;
      _characterPath = charPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Plant Feature Test")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _loadingPlant ? _buildLoading("식물 촬영 중...") : _buildPlantResult(),
            const SizedBox(height: 24),
            _loadingCharacter
                ? _buildLoading("캐릭터 생성 중...")
                : _buildCharacter(),
          ],
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
                child: CircularProgressIndicator(strokeWidth: 2)),
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
                  _characterPath ?? "assets/images/plant_face.png",
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover),
            ),
            const SizedBox(height: 12),
            Text("\"안녕! 나는 너의 $_plantType 친구야!\"", textAlign: TextAlign.center),
          ],
        ),
      );
}
