import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:todo_list_provider/app/core/notifier/default_change_notifier.dart';
import 'package:todo_list_provider/app/core/ui/messages.dart';

class DefaultListenerNotifier {
  final DefaultChangeNotifier changeNotifier;

  VoidCallback? _internalListener;

  DefaultListenerNotifier({required this.changeNotifier});

  void listener({
    required BuildContext context,
    VoidCallback? successCallback,
    void Function(String message)? errorCallback,
  }) {
    _internalListener = () {
      // Loading
      if (changeNotifier.loading) {
        Loader.show(context);
      } else {
        Loader.hide();
      }

      // Error
      if (changeNotifier.hasError) {
        final msg = changeNotifier.error ?? 'Erro interno';
        errorCallback?.call(msg);
        Messages.of(context).showError(msg);
        // opcional: limpar erro depois de exibir
        changeNotifier.setError(null);
      }

      // Success
      if (changeNotifier.isSuccess) {
        successCallback?.call();
        // opcional: resetar sucesso para não disparar de novo
        changeNotifier.resetState();
      }
    };

    changeNotifier.addListener(_internalListener!);
  }

  void dispose() {
    if (_internalListener != null) {
      changeNotifier.removeListener(_internalListener!);
      _internalListener = null;
    }
  }
}
