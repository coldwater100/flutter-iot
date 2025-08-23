import '../domain/plant_analysis_result.dart';

class PlantAnalysisModel extends PlantAnalysisResult {
  PlantAnalysisModel({
    required super.plantType,
    required super.accuracy,
    required super.description,
  });

  factory PlantAnalysisModel.fromJson(Map<String, dynamic> json) {
    return PlantAnalysisModel(
      plantType: json['plantType'],
      accuracy: (json['accuracy'] as num).toDouble(),
      description: json['description'],
    );
  }
}
