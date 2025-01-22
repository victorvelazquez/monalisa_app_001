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
                color: backgroundColor,
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

    // Mover ref.listen aquí
    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isNotEmpty) {
        _showSnackbar(next.errorMessage);
      }
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text('Iniciar', style: textStyles.titleLarge),
          const SizedBox(height: 20),
          CustomTextFormField(
            label: 'Usuario',
            isTopField: true,
            isBottomField: true,
            onChanged: ref.read(loginFormProvider.notifier).onUserNameChange,
            errorMessage:
                loginForm.isFormPosted ? loginForm.userName.errorMessage : null,
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            label: 'Contraseña',
            isTopField: true,
            isBottomField: true,
            obscureText: true,
            onChanged: ref.read(loginFormProvider.notifier).onPasswordChanged,
            onFieldSubmitted: (_) =>
                ref.read(loginFormProvider.notifier).onFormSubmit(),
            errorMessage:
                loginForm.isFormPosted ? loginForm.password.errorMessage : null,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: 'Ingresar',
              icon: const Icon(Icons.login_outlined),
              onPressed: loginForm.isPosting
                  ? null
                  : ref.read(loginFormProvider.notifier).onFormSubmit,
              isPosting: loginForm.isPosting,
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
