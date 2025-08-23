import '../../plant/domain/plant_analysis_result.dart';
import '../../plant/domain/plant_repository.dart';
import 'plant_remote_source.dart';

class PlantRepositoryImpl implements PlantRepository {
  final PlantRemoteSource remoteSource;
  PlantRepositoryImpl(this.remoteSource);

  @override
  Future<PlantAnalysisResult> analyzePlant(String userId) {
    return remoteSource.analyzePlant(userId);
  }

  @override
  Future<String> generateCharacter(String plantType) {
    return remoteSource.generateCharacter(plantType);
  }
}
