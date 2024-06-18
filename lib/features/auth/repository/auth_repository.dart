import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:garage/core/constants/firebase_constants.dart';
import 'package:garage/core/failure.dart';
import 'package:garage/core/provider/auth_provider.dart';
import 'package:garage/core/typedef.dart';
import 'package:garage/models/user_model.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: ref.read(firebaseAuthProvider),
    firebaseFirestore: ref.read(firebaseFirestoreProvider),
  ),
);

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firebaseFirestore;

  AuthRepository(
      {required FirebaseAuth auth,
      required FirebaseFirestore firebaseFirestore})
      : _auth = auth,
        _firebaseFirestore = firebaseFirestore;

  CollectionReference get _users =>
      _firebaseFirestore.collection(FirebaseConstants.userCollection);

  FutureEither<UserModel> createAccountWithGoogle(String email, String password,
      String name, String address, String contactNumber) async {
    try {
      if (email.isEmpty ||
          password.isEmpty ||
          name.isEmpty ||
          address.isEmpty ||
          contactNumber.isEmpty) {
        throw "Fill all the credentials";
      }
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userdata = UserModel(
          name: name,
          contactNumber: contactNumber,
          address: address,
          uid: userCredential.user!.uid,
          email: email);

      await _users.doc(userCredential.user!.uid).set(userdata.toMap());
      return right(userdata);
    } on FirebaseException catch (e) {
      return left(
        Failure(
          e.message!,
        ),
      );
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  FutureEither<UserModel> logInWithGoogle(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userModel = await getUserData(userCredential.user!.uid).first;
      return right(userModel);
    } on FirebaseException catch (e) {
      return left(
        Failure(
          e.message!,
        ),
      );
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  FutureEither<String> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return right("Password reset email sent successfully");
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid signOut() async {
    try {
      return right(_auth.signOut());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<User?> get authState => _auth.authStateChanges();

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
          (event) => UserModel.fromMap(event.data() as Map<String, dynamic>),
        );
  }
}
