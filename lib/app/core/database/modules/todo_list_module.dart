import 'package:flutter/material.dart';
import 'package:provider/single_child_widget.dart';
import 'package:todo_list_provider/app/core/database/modules/todo_list_page.dart';

/// Classe base para módulos com rotas e bindings (injeções).
abstract class TodoListModule {
  /// Rotas disponíveis no módulo
  final Map<String, WidgetBuilder> _routers;

  /// Injeções de dependência para o módulo
  final List<SingleChildWidget> _bindings;

  TodoListModule({
    List<SingleChildWidget>? bindings,
    required Map<String, WidgetBuilder> routers,
  }) : _routers = routers,
       _bindings = bindings ?? []; // garante que bindings nunca será nulo

  Map<String, WidgetBuilder> get routers {
    return _routers.map(
      (key, pageBuilder) => MapEntry(
        key,
        (_) => TodoListPage(bindings: _bindings, page: pageBuilder),
      ),
    );
  }
}
