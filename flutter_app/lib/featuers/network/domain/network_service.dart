import '../data/network_repository.dart';
import 'event.dart';

class NetworkService {
  final NetworkRepository repo;

  NetworkService(this.repo);

  // REST 예시
  Future<void> sendSensorData(String sensor, dynamic value) async {
    await repo.sendData({"sensor": sensor, "value": value});
  }

  // WebSocket 이벤트 구독
  Stream<Event> get eventStream {
    return repo.events.map((raw) {
      return Event.fromJson(raw);
    });
  }

  void sendWSMessage(String msg) => repo.sendMessage(msg);
}
