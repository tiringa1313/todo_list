import 'package:flutter/widgets.dart';

class DefaultChangeNotifier extends ChangeNotifier {
  bool _loading = false;
  String? _error;
  bool _success = false;

  bool get loading => _loading;
  String? get error => _error;
  bool get hasError => _error != null;
  bool get isSuccess => _success;

  void showLoading() {
    _loading = true;
    notifyListeners();
  }

  void hideLoading() {
    _loading = false;
    notifyListeners();
  }

  void success() {
    _success = true;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void showLoadingAndResetState() {
    _loading = true;
    _error = null;
    _success = false;
    notifyListeners();
  }

  void resetState() {
    _error = null;
    _success = false;
    notifyListeners();
  }
}
