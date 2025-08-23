import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/notifier/default_listener_notifier.dart';
import 'package:todo_list_provider/app/core/ui/messages.dart';
import 'package:todo_list_provider/app/core/widget/todo_list_field.dart';
import 'package:todo_list_provider/app/core/widget/todo_list_logo.dart';
import 'package:todo_list_provider/app/modules/auth/login/login_controller.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passWordEC = TextEditingController();
  final _emailFocus = FocusNode();

  late final DefaultListenerNotifier _listener;

  @override
  void initState() {
    super.initState();

    _listener = DefaultListenerNotifier(
      changeNotifier: context.read<LoginController>(),
    );

    _listener.listener(
      context: context,
      everCallback: (notifier, listenerInstance) {
        if (notifier is LoginController) {
          if (notifier.hasInfo) {
            Messages.of(context).showInfo(notifier.infoMessage!);
          }
        }
      },
      successCallback: (notifier, listenerInstance) {
        print('Login efetuado com sucesso!');
      },
      errorCallback: (msg, notifier, listenerInstance) {
        print('Erro no login: $msg');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 100),
                    TodoListLogo(),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      child: Form(
                        key: _formKey,

                        child: Column(
                          children: [
                            TodoListField(
                              label: 'E-mail',
                              controller: _emailEC,
                              focusNode: _emailFocus,
                              validator: Validatorless.multiple([
                                Validatorless.required('E-mail obrigatorio'),
                                Validatorless.email('E-mail inválido'),
                              ]),
                            ),

                            SizedBox(height: 20),
                            TodoListField(
                              label: 'Senha',
                              controller: _passWordEC,
                              obscureText: true,
                              validator: Validatorless.multiple([
                                Validatorless.required('Senha obrigatoria'),
                                Validatorless.min(
                                  6,
                                  'Senha deve conter pelo menos 6 caracteres',
                                ),
                              ]),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    if (_emailEC.text.isNotEmpty) {
                                      context
                                          .read<LoginController>()
                                          .forgotPassword(_emailEC.text);
                                    } else {
                                      _emailFocus.requestFocus();

                                      Messages.of(context).showError(
                                        'Digite um email para recuperar a senha',
                                      );
                                    }
                                  },
                                  child: Text('Esqueceu sua senha?'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    final formValid =
                                        _formKey.currentState?.validate() ??
                                        false;

                                    if (formValid) {
                                      final email = _emailEC.text;
                                      final password = _passWordEC.text;
                                      context.read<LoginController>().login(
                                        email,
                                        password,
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text('Login'),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0XFFf0f3f7),
                          border: Border(
                            top: BorderSide(
                              width: 2,
                              color: Colors.grey.withAlpha(50),
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 30),
                            SignInButton(
                              Buttons.Google,
                              text: 'Continue com o Google',
                              padding: EdgeInsets.all(5),
                              shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              onPressed: () {},
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Não tem conta?'),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pushNamed('/register');
                                  },
                                  child: Text('Cadastre-se'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
