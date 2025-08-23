import 'plant_analysis_model.dart';

class PlantRemoteSource {
  Future<PlantAnalysisModel> analyzePlant(String userId) async {
    // TODO: 실제 서버 API 호출 부분
    await Future.delayed(const Duration(seconds: 3));
    return PlantAnalysisModel(
      plantType: "몬스테라",
      accuracy: 0.92,
      description: "크고 넓은 잎, 독특한 잎 모양",
    );
  }

  Future<String> generateCharacter(String plantType) async {
    // TODO: 실제 서버 캐릭터 생성 API 호출
    await Future.delayed(const Duration(seconds: 3));
    return "assets/images/plant_face.png";
  }
}
