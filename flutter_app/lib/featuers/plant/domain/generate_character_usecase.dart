import 'plant_repository.dart';

class GenerateCharacterUsecase {
  final PlantRepository repository;
  GenerateCharacterUsecase(this.repository);

  Future<String> execute(String plantType) {
    return repository.generateCharacter(plantType);
  }
}
