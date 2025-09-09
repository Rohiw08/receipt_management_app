import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:receipt_creator/features/auth/repository/auth_repository.dart';
import 'package:receipt_creator/models/user_model.dart';
import 'package:receipt_creator/core/utils.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
      authRepository: ref.watch(authRepositoryProvider), ref: ref),
);

final authStateProvider = StreamProvider(
  (ref) {
    final authController = ref.watch(authControllerProvider.notifier);
    return authController.authState;
  },
);

final getUserdataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authState => _authRepository.authState;

  void createAccountWithGoogle(BuildContext context,
      {required String email,
      required String password,
      required String name,
      required String address,
      required String contactNumber}) async {
    state = true;
    final user = await _authRepository.createAccountWithGoogle(
        email, password, name, address, contactNumber);
    state = false;
    user.fold(
      (error) => showSnackBar(context, error.message),
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  void logInWithGoogle(BuildContext context,
      {required String email, required String password}) async {
    state = true;
    final user = await _authRepository.logInWithGoogle(email, password);
    state = false;
    user.fold(
      (error) => showSnackBar(context, error.message),
      (r) => (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  void sendPasswordResetEmail(BuildContext context,
      {required String email}) async {
    state = true;
    final user = await _authRepository.sendPasswordResetEmail(email: email);
    state = false;
    user.fold(
      (error) => showSnackBar(context, error.message),
      (done) => showSnackBar(context, done),
    );
  }

  void signOut() {
    state = true;
    _authRepository.signOut();
    state = false;
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }
}
