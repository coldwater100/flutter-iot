import 'package:web_socket_channel/web_socket_channel.dart';

class WSClient {
  late WebSocketChannel channel;

  WSClient(String wsUrl) {
    channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    print("[WSClient] Connecting to $wsUrl");
  }

  Stream<String> get stream => channel.stream.cast<String>();

  void send(String message) {
    print("[WSClient] Sending: $message");
    channel.sink.add(message);
  }

  void close() {
    print("[WSClient] Closing connection");
    channel.sink.close();
  }
}
