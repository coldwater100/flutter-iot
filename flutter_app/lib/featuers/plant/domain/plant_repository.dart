import 'plant_analysis_result.dart';

abstract class PlantRepository {
  Future<PlantAnalysisResult> analyzePlant(String userId);
  Future<String> generateCharacter(String plantType);
}
