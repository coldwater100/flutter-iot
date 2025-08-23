import 'plant_analysis_result.dart';
import 'plant_repository.dart';

class AnalyzePlantUsecase {
  final PlantRepository repository;
  AnalyzePlantUsecase(this.repository);

  Future<PlantAnalysisResult> execute(String userId) {
    return repository.analyzePlant(userId);
  }
}
