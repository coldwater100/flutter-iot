import 'chat_message.dart';

abstract class ChatRepository {
  Future<List<ChatMessage>> fetchInitialMessages();
  Future<ChatMessage> sendMessage(String text);
}
