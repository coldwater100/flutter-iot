import 'dart:convert';
import 'rest_client.dart';
import 'ws_client.dart';

class NetworkRepository {
  final RestClient restClient;
  final WSClient wsClient;

  NetworkRepository({
    required this.restClient,
    required this.wsClient,
  });

  // REST API
  Future<Map<String, dynamic>> getHello() => restClient.getHello();
  Future<Map<String, dynamic>> sendData(Map<String, dynamic> data) =>
      restClient.sendData(data);
  Future<Map<String, dynamic>> createItem(Map<String, dynamic> item) =>
      restClient.createItem(item);
  Future<Map<String, dynamic>> notify(Map<String, dynamic> body) =>
      restClient.notify(body);

  // WebSocket → String(JSON) → Map 변환
  late final Stream<Map<String, dynamic>> _events = wsClient.stream.map((raw) {
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      print("[NetworkRepository] decoded: $decoded");
      return decoded;
    } catch (e) {
      print("[NetworkRepository] decode error: $e, raw=$raw");
      return <String, dynamic>{};
    }
  }).asBroadcastStream();

  Stream<Map<String, dynamic>> get events => _events;

  void sendMessage(String msg) => wsClient.send(msg);
  void disconnect() => wsClient.close();
}
