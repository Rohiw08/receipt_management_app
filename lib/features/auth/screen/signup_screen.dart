import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receipt_creator/core/common/black_button.dart';
import 'package:receipt_creator/core/common/text_fields/auth_text_field.dart';
import 'package:receipt_creator/core/common/text_fields/password_text_field.dart';
import 'package:receipt_creator/core/constants/constants.dart';
import 'package:receipt_creator/features/auth/controller/auth_controller.dart';
import 'package:receipt_creator/l10n/app_localizations.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void createAccount(
      {required String email,
      required String password,
      required String name,
      required String address,
      required String contactNumber}) {
    ref.read(authControllerProvider.notifier).createAccountWithGoogle(context,
        email: email,
        password: password,
        name: name,
        address: address,
        contactNumber: contactNumber);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  Constants.loginScreenLogo,
                  height: 250,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.register,
                // AppLocalizations.of(context)!.signUp,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              const SizedBox(height: 10),
              MyTextField(
                controller: _userNameController,
                hintText: AppLocalizations.of(context)!.storeName,
                // AppLocalizations.of(context)!.storeName,
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _contactNumberController,
                hintText: AppLocalizations.of(context)!.contactNumber,
                // AppLocalizations.of(context)!.contactNumber,
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _addressController,
                hintText: AppLocalizations.of(context)!.storeAddress,
                // AppLocalizations.of(context)!.storeAddress,
                obscureText: false,
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: MyButton(
                  buttonText: AppLocalizations.of(context)!.register,
                  // AppLocalizations.of(context)!.signUp,
                  onTap: () => createAccount(
                    email: _emailController.text,
                    password: _passwordController.text,
                    name: _userNameController.text,
                    address: _addressController.text,
                    contactNumber: _contactNumberController.text,
                  ),
                  isLoading: isLoading,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
