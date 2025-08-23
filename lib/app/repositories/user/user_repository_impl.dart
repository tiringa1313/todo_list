import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // kDebugMode, debugPrint
import 'package:todo_list_provider/app/repositories/user/user_repository.dart';

/// Exceção simples para a camada de UI
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
        debugPrint('Auth error (register): ${e.code} | ${e.message}');
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

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        debugPrint('Auth error (login): ${e.code} | ${e.message}');
      }

      // Códigos mais comuns no FlutterFire atual
      switch (e.code) {
        case 'invalid-credential': // email ou senha incorretos
        case 'wrong-password': // ainda pode aparecer em alguns SDKs
        case 'user-not-found':
          throw AuthException(message: 'Login ou senha inválidos.');
        case 'invalid-email':
          throw AuthException(message: 'E-mail inválido.');
        case 'user-disabled':
          throw AuthException(message: 'Usuário desabilitado.');
        case 'too-many-requests':
          throw AuthException(
            message: 'Muitas tentativas. Tente novamente mais tarde.',
          );
        default:
          throw AuthException(message: e.message ?? 'Erro ao realizar login.');
      }
    } catch (_) {
      throw AuthException(
        message: 'Ocorreu um erro inesperado. Tente novamente.',
      );
    }
  }

  @override
  Future<User?> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      // Tratar erros específicos
      if (e.code == 'user-not-found') {
        throw Exception('Nenhum usuário encontrado com este e-mail.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Formato de e-mail inválido.');
      } else {
        throw Exception('Erro ao enviar e-mail de recuperação: ${e.message}');
      }
    }
  }
}
