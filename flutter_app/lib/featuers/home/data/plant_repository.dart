import '../domain/plant_quotes.dart';

class PlantRepository {
  List<String> getQuotes() {
    return PlantQuotes.quotes;
  }
}
