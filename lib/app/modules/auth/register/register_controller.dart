import 'package:todo_list_provider/app/core/notifier/default_change_notifier.dart';
import 'package:todo_list_provider/app/services/user/user_service.dart';
import 'package:todo_list_provider/app/repositories/user/user_repository_impl.dart'; // p/ AuthException

class RegisterController extends DefaultChangeNotifier {
  final UserService _userService;

  RegisterController({required UserService userService})
    : _userService = userService;

  Future<void> registerUser(String email, String password) async {
    try {
      showLoadingAndResetState();
      await _userService.register(email, password);
      hideLoading();
      success(); // 🔔 DefaultListenerNotifier vai navegar
    } on AuthException catch (e) {
      hideLoading();
      setError(e.message); // 🔔 DefaultListenerNotifier mostra SnackBar
    } catch (_) {
      hideLoading();
      setError('Erro inesperado'); // fallback seguro
    }
  }
}
