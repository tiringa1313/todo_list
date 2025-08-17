import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // kDebugMode, debugPrint
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
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        debugPrint('Auth error (register): ${e.code}');
      }

      switch (e.code) {
        case 'email-already-in-use':
          throw AuthException(
            message:
                'E-mail já cadastrado. Tente fazer login ou use "Esqueci minha senha".',
          );
        case 'invalid-email':
          throw AuthException(message: 'E-mail inválido.');
        case 'weak-password':
          throw AuthException(
            message: 'Senha fraca. Use ao menos 6 caracteres.',
          );
        default:
          throw AuthException(
            message: e.message ?? 'Não foi possível criar sua conta.',
          );
      }
    } catch (_) {
      throw AuthException(
        message: 'Ocorreu um erro inesperado. Tente novamente.',
      );
    }
  }
}
