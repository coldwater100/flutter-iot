import 'auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  Future<bool> execute(String email, String password) {
    return repository.login(email, password);
  }

  Future<bool> qrExecute(String qrCode) {
    return repository.qrLogin(qrCode);
  }
}
