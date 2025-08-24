// app_config.dart
class AppConfig {
  static const String baseIp = "192.168.0.41";
  static const String port = "8000";

  static String get restBaseUrl => "http://$baseIp:$port";
  static String get wsUrl => "ws://$baseIp:$port/ws";
}
