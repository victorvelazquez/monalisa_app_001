import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monalisa_app_001/config/config.dart';
import 'package:monalisa_app_001/features/auth/presentation/providers/auth_provider.dart';
import 'package:monalisa_app_001/features/auth/presentation/providers/login_form_provider.dart';
import 'package:monalisa_app_001/features/shared/shared.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            SizedBox(
              height: size.height - 385,
              child: Center(
                child: Image.asset(
                  'assets/images/logo-monalisa.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              height: 385,
              decoration: BoxDecoration(
                color: themeColorGrayLight,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: const _LoginForm(),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginForm extends ConsumerStatefulWidget {
  const _LoginForm();

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<_LoginForm> {
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final loginForm = ref.watch(loginFormProvider);
    final textStyles = Theme.of(context).textTheme;

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isNotEmpty) {
        _showSnackbar(next.errorMessage);
      }
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          SizedBox(height: 20),
          GestureDetector(
            onLongPress: () {
              ref.read(authProvider.notifier).setShowUrlApi();
              setState(() {});
            },
            child: Text('Iniciar', style: textStyles.titleLarge),
          ),
          const SizedBox(height: 20),
          ref.read(authProvider).showUrlApi ? CustomTextFormField(
            label: 'Url Api',
            initialValue: ref.read(authProvider).urlApi,
            onChanged: ref.read(authProvider.notifier).onUrlApiChanged,
            border: false,
          ) : const SizedBox(),
          ref.read(authProvider).showUrlApi ? const SizedBox(height: 16) : const SizedBox(),
          CustomTextFormField(
            label: 'Usuario',
            onChanged: ref.read(loginFormProvider.notifier).onUserNameChange,
            errorMessage:
                loginForm.isFormPosted ? loginForm.userName.errorMessage : null,
            border: false,
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            onChanged: ref.read(loginFormProvider.notifier).onPasswordChanged,
            onFieldSubmitted: (_) =>
                ref.read(loginFormProvider.notifier).onFormSubmit(),
            errorMessage:
                loginForm.isFormPosted ? loginForm.password.errorMessage : null,
            border: false,
          ),
          const SizedBox(height: 16),
          CustomFilledButton(
            label: 'Ingresar',
            icon: const Icon(Icons.login_outlined),
            onPressed: loginForm.isPosting
                ? null
                : ref.read(loginFormProvider.notifier).onFormSubmit,
            isPosting: loginForm.isPosting,
            expand: true,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Future<dynamic> showInsertUrl(BuildContext context) {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(themeBorderRadius),
  //         ),
  //         title: Text('URL del API'),
  //         content: CustomTextFormField(
  //           initialValue: ref.read(authProvider).urlApi,
  //           onChanged: ref.read(authProvider.notifier).onUrlApiChanged,
  //           errorMessage: ref.read(authProvider).urlApiError != '' ? ref.read(authProvider).urlApiError : null,
  //           border: false,
  //           autofocus: true,
  //         ),
  //         actions: <Widget>[
  //           CustomFilledButton(
  //             onPressed: () async {
  //               final isValid =
  //                   await ref.read(authProvider.notifier).setUrlApi();
  //               if (isValid) {
  //                 if (context.mounted) {
  //                   Navigator.of(context).pop();
  //                 }
  //               }
  //             },
  //             label: 'Guardar',
  //             icon: const Icon(Icons.check),
  //           ),
  //           CustomFilledButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             label: 'Cancelar',
  //             icon: const Icon(Icons.close_rounded),
  //             buttonColor: themeColorGray,
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
