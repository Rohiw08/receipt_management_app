import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receipt_creator/core/common/black_button.dart';
import 'package:receipt_creator/core/common/text_fields/auth_text_field.dart';
import 'package:receipt_creator/core/common/text_fields/password_text_field.dart';
import 'package:receipt_creator/core/constants/constants.dart';
import 'package:receipt_creator/features/auth/controller/auth_controller.dart';
import 'package:receipt_creator/features/auth/screen/forget_password_screen.dart';
import 'package:receipt_creator/features/auth/screen/signup_screen.dart';
import 'package:receipt_creator/l10n/app_localizations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void logInWithGoogle({required String email, required String password}) {
    ref
        .read(authControllerProvider.notifier)
        .logInWithGoogle(context, email: email, password: password);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    Constants.loginScreenLogo,
                    height: 250,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    AppLocalizations.of(context)!.hello,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: _emailController,
                  hintText: AppLocalizations.of(context)!.email,
                  // AppLocalizations.of(context)!.email,
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                PasswordTextField(
                  controller: _passwordController,
                  hintText: AppLocalizations.of(context)!.password,
                  // AppLocalizations.of(context)!.password,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const PasswordResetScreen(),
                          ));
                        },
                        child: Text(
                          AppLocalizations.of(context)!.forgetPassword,
                          // AppLocalizations.of(context)!.forgotPasswordLabel,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const SignUpScreen(),
                            ),
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.register,
                          //AppLocalizations.of(context)!.registerNowLabel,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: MyButton(
                    buttonText: "Login",
                    // AppLocalizations.of(context)!.loginButtonLabel,
                    onTap: () => logInWithGoogle(
                        email: _emailController.text,
                        password: _passwordController.text),
                    isLoading: isLoading,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
