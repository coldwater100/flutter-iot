import 'chat_repository.dart';
import 'chat_message.dart';

class SendMessageUsecase {
  final ChatRepository repository;

  SendMessageUsecase(this.repository);

  Future<ChatMessage> execute(String text) {
    return repository.sendMessage(text);
  }
}
