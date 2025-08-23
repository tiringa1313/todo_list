import 'package:flutter/foundation.dart';

class DefaultChangeNotifier extends ChangeNotifier {
  // Estados básicos
  bool _loading = false;
  bool _success = false;
  String? _error;

  // ---- INFO (mensagens informativas) ----
  String? _info;

  // Getters
  bool get loading => _loading;
  bool get isSuccess => _success;

  String? get error => _error;
  bool get hasError => _error != null;

  String? get info => _info;
  bool get hasInfo => _info != null;

  // Setters helpers
  void setError(String? message) => _error = message;
  void setInfo(String? message) => _info = message;

  // Ciclo de estados
  void showLoadingAndResetState() {
    _loading = true;
    _success = false;
    _error = null;
    _info = null; // zera info ao iniciar um fluxo
  }

  void hideLoading() => _loading = false;

  void success() => _success = true;

  /// Reseta apenas sinalizadores de sucesso/erro.
  /// (não zera _info aqui; quem exibiu a info deve limpá-la)
  void resetState() {
    _success = false;
    _error = null;
  }
}
