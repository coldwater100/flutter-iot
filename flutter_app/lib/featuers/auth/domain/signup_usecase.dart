import 'user_entity.dart';
import 'auth_repository.dart';

class SignupUsecase {
  final AuthRepository repository;

  SignupUsecase(this.repository);

  Future<bool> execute(UserEntity user) {
    return repository.signup(user);
  }
}
