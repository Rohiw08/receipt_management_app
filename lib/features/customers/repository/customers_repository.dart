import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:receipt_creator/core/constants/firebase_constants.dart';
import 'package:receipt_creator/core/failure.dart';
import 'package:receipt_creator/core/provider/auth_provider.dart';
import 'package:receipt_creator/core/typedef.dart';
import 'package:receipt_creator/models/customer_info.dart';

final customerRepositoryProvider = Provider((ref) => CustomerRepository(
    firebaseFirestore: ref.read(firebaseFirestoreProvider),
    firebaseStorage: ref.read(firebaseStorageProvider)));

class CustomerRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;

  CustomerRepository({
    required FirebaseFirestore firebaseFirestore,
    required FirebaseStorage firebaseStorage,
  })  : _firebaseFirestore = firebaseFirestore,
        _firebaseStorage = firebaseStorage;

  Reference imageRef(String imagePath, String uid, String uuid) =>
      _firebaseStorage.ref().child("$imagePath/$uid/$uuid");

  CollectionReference _customers(String uid) => _firebaseFirestore
      .collection(FirebaseConstants.userCollection)
      .doc(uid)
      .collection(FirebaseConstants.customersCollection);

  FutureVoid createCustomer(
      String uid, CustomerInformation customerInformation) async {
    try {
      return right(_customers(uid)
          .doc(customerInformation.uid)
          .set(customerInformation.toMap()));
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid deleteCustomer(String uid, String uuid) async {
    try {
      await deleteImageFromStorage(uid, uuid);
      return right(_customers(uid).doc(uuid).delete());
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid deleteImageFromStorage(String uid, String uuid) async {
    try {
      return right(imageRef("/receipt", uid, uuid).delete());
    } on FirebaseException catch (e) {
      return left(Failure(e.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<String> uploadImageToFirebaseStorage({
    required String imagePath,
    required String uid,
    required String uuid,
    required File image,
  }) async {
    try {
      UploadTask uploadTask = imageRef(imagePath, uid, uuid).putFile(image);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      String imageUrl = await snapshot.ref.getDownloadURL();
      return right(imageUrl);
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid updateCustomerdata(String uuid, String uid, String url) async {
    try {
      return right(_customers(uid).doc(uuid).update({"receiptUrl": url}));
    } on FirebaseException catch (e) {
      return left(Failure(e.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<CustomerInformation> getCustomer(String uid, String uuid) async {
    try {
      final data = await _customers(uid).doc(uuid).get();
      final customer =
          CustomerInformation.fromMap(data.data() as Map<String, dynamic>);
      return right(customer);
    } on FirebaseException catch (e) {
      return left(Failure(e.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<CustomerInformation>> customersListStream(String uid) {
    return _customers(uid)
        .orderBy("day", descending: true)
        .snapshots()
        .map((event) {
      final List<CustomerInformation> customers = [];
      for (var doc in event.docs) {
        customers.add(
            CustomerInformation.fromMap(doc.data() as Map<String, dynamic>));
      }
      return customers;
    });
  }

  Stream<List<CustomerInformation>> searchCustomer(
      String uid, String query, String searchValue) {
    return _customers(uid)
        .where(
          searchValue,
          isGreaterThanOrEqualTo: query.isEmpty ? '' : query,
          isLessThan: query.isEmpty
              ? ''
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map((querySnapshot) {
      List<CustomerInformation> customers = [];
      for (var doc in querySnapshot.docs) {
        customers.add(
            CustomerInformation.fromMap(doc.data() as Map<String, dynamic>));
      }
      return customers;
    });
  }
}
