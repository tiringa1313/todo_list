import 'package:flutter/material.dart';
import 'package:todo_list_provider/app/core/notifier/default_change_notifier.dart';
import 'package:todo_list_provider/app/exception/auth_exception.dart';
import 'package:todo_list_provider/app/services/user/user_service.dart';

class LoginController extends DefaultChangeNotifier {
  final UserService _userService;

  /// Mensagem informativa (ex.: fluxo de "esqueci minha senha")
  String? infoMessage;

  LoginController({required UserService userService})
    : _userService = userService;

  bool get hasInfo => infoMessage != null;

  Future<void> login(String email, String password) async {
    try {
      showLoadingAndResetState();
      infoMessage = null;
      notifyListeners();

      final user = await _userService.login(email.trim(), password);

      if (user != null) {
        success();
      } else {
        setError('Usuário ou senha inválidos.');
      }
    } on AuthException catch (e) {
      setError(e.message);
    } catch (_) {
      setError('Falha ao efetuar login. Tente novamente.');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      showLoadingAndResetState();
      infoMessage = null;
      notifyListeners();

      // Envia a solicitação de redefinição (retorna OK mesmo se e-mail não existir)
      await _userService.forgotPassword(email.trim());

      // Mensagem genérica (boa prática de segurança)
      infoMessage =
          'Se existir uma conta com este e-mail, você receberá um link de redefinição.';
    } on AuthException catch (e) {
      setError(e.message);
    } catch (_) {
      setError('Erro ao tentar redefinir a senha.');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
