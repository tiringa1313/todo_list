import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'default_change_notifier.dart';
import '../ui/messages.dart';

// Tipagens
typedef SuccessCallback =
    void Function(
      DefaultChangeNotifier notifier,
      DefaultListenerNotifier listenerInstance,
    );
typedef ErrorCallback =
    void Function(
      String message,
      DefaultChangeNotifier notifier,
      DefaultListenerNotifier listenerInstance,
    );
typedef InfoCallback =
    void Function(
      String message,
      DefaultChangeNotifier notifier,
      DefaultListenerNotifier listenerInstance,
    );
typedef EverCallback =
    void Function(
      DefaultChangeNotifier notifier,
      DefaultListenerNotifier listenerInstance,
    );

class DefaultListenerNotifier {
  final DefaultChangeNotifier changeNotifier;
  VoidCallback? _internalListener;

  DefaultListenerNotifier({required this.changeNotifier});

  void listener({
    required BuildContext context,
    SuccessCallback? successCallback,
    ErrorCallback? errorCallback,
    InfoCallback? infoCallback,
    EverCallback? everCallback,
  }) {
    _internalListener = () {
      // Loading (protege hide/show)
      if (changeNotifier.loading) {
        Loader.show(context);
      } else {
        try {
          Loader.hide();
        } catch (_) {
          // ignora: algumas libs estouram se não houver overlay aberto
        }
      }

      // --- ERROR (sem '!' nunca) ---
      final err = changeNotifier.error;
      if (err != null && err.isNotEmpty) {
        errorCallback?.call(err, changeNotifier, this);
        Messages.of(context).showError(err);
        changeNotifier.setError(null); // evita repetir
      }

      // --- SUCCESS ---
      if (changeNotifier.isSuccess) {
        successCallback?.call(changeNotifier, this);
        changeNotifier.resetState(); // limpa success/erro
      }

      // --- INFO (sem '!' nunca) ---
      final info = changeNotifier.info;
      if (info != null && info.isNotEmpty) {
        infoCallback?.call(info, changeNotifier, this);
        Messages.of(context).showInfo(info);
        changeNotifier.setInfo(null); // evita repetir
      }

      // --- EVER/ALWAYS ---
      everCallback?.call(changeNotifier, this);
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
