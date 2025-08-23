import 'dart:math';
import '../data/plant_repository.dart';

class PlantService {
  final PlantRepository repository;
  final Random _random = Random();

  PlantService(this.repository);

  /// 공용 랜덤 문구
  String getRandomQuote() {
    final quotes = repository.getQuotes();
    return quotes[_random.nextInt(quotes.length)];
  }

  /// 식물 버튼/서버 이벤트 → 랜덤 문구
  String getQuoteForPlant() {
    return getRandomQuote();
  }

  /// 채팅 버튼 → 문구 변경 없음
  String? getQuoteForChat() {
    return null;
  }
}
