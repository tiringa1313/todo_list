import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list_provider/app/repositories/user/user_repository.dart';

// Exceção simples para sua camada de UI
class AuthException implements Exception {
  final String message;
  AuthException({required this.message});
  @override
  String toString() => message;
}

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepositoryImpl({required FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;

  @override
  Future<User?> register(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e, s) {
      // logs opcionais
      // ignore: avoid_print
      print('FirebaseAuthException(register): ${e.code}\n$s');

      if (e.code == 'email-already-in-use') {
        throw AuthException(
          message:
              'E-mail já cadastrado. Tente fazer login ou use "Esqueci minha senha".',
        );
      } else if (e.code == 'invalid-email') {
        throw AuthException(message: 'E-mail inválido.');
      } else if (e.code == 'weak-password') {
        throw AuthException(message: 'Senha fraca. Use ao menos 6 caracteres.');
      } else {
        throw AuthException(
          message: 'Não foi possível criar sua conta. Tente novamente.',
        );
      }
    } catch (e, s) {
      // ignore: avoid_print
      print('Erro inesperado(register): $e\n$s');
      throw AuthException(
        message: 'Ocorreu um erro inesperado. Tente novamente.',
      );
    }
  }
}
