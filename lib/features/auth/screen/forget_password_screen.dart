import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:garage/features/auth/controller/auth_controller.dart';

import 'package:garage/core/common/black_button.dart';
import 'package:garage/core/common/text_fields/auth_text_field.dart';
import 'package:garage/core/constants/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordResetScreen extends ConsumerStatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PasswordResetScreenState();
}

class _PasswordResetScreenState extends ConsumerState<PasswordResetScreen> {
  final TextEditingController _emailController = TextEditingController();

  void sendPasswordResetEmail({required String email}) {
    ref
        .read(authControllerProvider.notifier)
        .sendPasswordResetEmail(context, email: email);
  }

  @override
  void dispose() {
    _emailController.dispose();
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Center(
                  child: Image.asset(
                    Constants.loginScreenLogo,
                    height: 250,
                  ),
                ),
                const SizedBox(height: 50),
                Text(
                  AppLocalizations.of(context)!.forgetPassword,
                  // AppLocalizations.of(context)!.enterPasswordText,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: _emailController,
                  hintText: AppLocalizations.of(context)!.email,
                  obscureText: false,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: MyButton(
                    buttonText:
                        AppLocalizations.of(context)!.sendEmail,
                    onTap: () =>
                        sendPasswordResetEmail(email: _emailController.text),
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
