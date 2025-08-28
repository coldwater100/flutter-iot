import '../domain/chat_repository.dart';
import '../domain/chat_message.dart';

class ChatRepositoryImpl implements ChatRepository {
  final List<ChatMessage> _messages = [
    ChatMessage(sender: "plant", text: "안녕! 나는 너의 호야 친구야."),
  ];

  @override
  Future<List<ChatMessage>> fetchInitialMessages() async {
    return _messages;
  }

  @override
  Future<ChatMessage> sendMessage(String text) async {
    // 유저 메시지 추가
    final userMsg = ChatMessage(sender: "user", text: text);
    _messages.add(userMsg);

    // 🌱 식물 응답 (임시 로직)
    final reply = ChatMessage(
      sender: "plant",
      text: "나는 네 메시지를 잘 받았어! (AI 응답 자리)",
    );
    _messages.add(reply);

    return reply;
  }
}
