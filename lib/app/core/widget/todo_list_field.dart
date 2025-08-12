import 'package:flutter/material.dart';
import 'package:todo_list_provider/app/core/ui/todo_list_icons.dart';

class TodoListField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final IconButton? suffixIconButton;
  final ValueNotifier<bool> obscureTextVN;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;

  TodoListField({
    Key? key,
    required this.label,
    this.obscureText = false,
    this.suffixIconButton,
    this.controller,
    this.validator,
  }) : assert(
         obscureText == true ? suffixIconButton == null : true,
         'ObscureText não pode ser enviado em conjunto com suffixIconButton',
       ),
       obscureTextVN = ValueNotifier(obscureText),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      // Escuta mudanças em obscureTextVN (ex: clicou no olho)
      valueListenable: obscureTextVN,

      // Toda vez que obscureTextVN.value mudar, esse builder é executado
      builder: (_, obscureTextValue, child) {
        return TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(fontSize: 15, color: Colors.black),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.red),
            ),
            isDense: true, // deixa mais compacto
            // Define o ícone final do campo (olhinho ou personalizado)
            suffixIcon:
                this.suffixIconButton ??
                (obscureText == true
                    ? IconButton(
                        onPressed: () {
                          // Inverte o valor (mostra/oculta senha)
                          obscureTextVN.value = !obscureTextValue;
                        },
                        icon: Icon(
                          !obscureTextValue
                              ? TodoListIcons
                                    .eye_slash // senha visível
                              : TodoListIcons.eye, // senha oculta
                          size: 15,
                        ),
                      )
                    : null),
          ),

          // Mostra texto oculto ou não conforme obscureTextValue
          obscureText: obscureTextValue,
        );
      },
    );
  }
}
