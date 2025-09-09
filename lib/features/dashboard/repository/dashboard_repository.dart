import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receipt_creator/core/constants/firebase_constants.dart';
import 'package:receipt_creator/core/provider/auth_provider.dart';
import 'package:receipt_creator/features/auth/controller/auth_controller.dart';
import 'package:receipt_creator/models/customer_info.dart';

final dashboardRepositoryProvider = Provider((ref) {
  return DashboardRepository(
      firebaseFirestore: ref.read(firebaseFirestoreProvider));
});

final analyzedStreamProvider =
    StreamProvider.family<List<CustomerInformation>, String>((ref, today) {
  final dashboardRepo = ref.watch(dashboardRepositoryProvider);
  final uid = ref.watch(userProvider)?.uid;
  if (uid != null) {
    return dashboardRepo.analysisStream(uid, today);
  } else {
    throw Exception("User not authenticated");
  }
});

class DashboardRepository {
  final FirebaseFirestore _firebaseFirestore;

  DashboardRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  Stream<List<CustomerInformation>> analysisStream(String uid, String today) {
    final month = today.substring(3, 5);
    final year = today.substring(6);
    return _customers(uid)
        .where('year', isEqualTo: year)
        .where('month', isEqualTo: month)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                CustomerInformation.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  CollectionReference _customers(String uid) => _firebaseFirestore
      .collection(FirebaseConstants.userCollection)
      .doc(uid)
      .collection(FirebaseConstants.customersCollection);
}
