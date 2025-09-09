import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:receipt_creator/core/common/error_text.dart';
import 'package:receipt_creator/core/failure.dart';
import 'package:receipt_creator/core/typedef.dart';
import 'package:receipt_creator/core/utils.dart';
import 'package:receipt_creator/features/auth/controller/auth_controller.dart';
import 'package:receipt_creator/features/customers/repository/customers_repository.dart';
import 'package:receipt_creator/models/customer_info.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:receipt_creator/l10n/app_localizations.dart';

final searchValueProvider = StateProvider((ref) => "contactNumber");

final customersListProvider = StreamProvider((ref) {
  final customers = ref.read(customerFormControllerProvider).customersList();
  return customers;
});

final customerFormControllerProvider = Provider(
  (ref) => CustomerFormController(
    ref: ref,
    customerFormRepository: ref.watch(customerRepositoryProvider),
  ),
);

final searchCustomerProvider = StreamProvider.family((ref, String query) {
  final uid = ref.read(userProvider)!.uid;
  return ref.watch(customerFormControllerProvider).searchCustomer(uid, query);
});

class CustomerFormController {
  final CustomerRepository _customerFormRepository;
  final Ref _ref;
  CustomerFormController({
    required Ref ref,
    required CustomerRepository customerFormRepository,
  })  : _ref = ref,
        _customerFormRepository = customerFormRepository;

  FutureEither<bool> createCustomer(
      String uuid,
      String contactNumber,
      String vehicleNumber,
      double vehicleRunning,
      double vehicleNextRunning,
      double totalAmount,
      BuildContext context) async {
    try {
      DateTime date = DateTime.now();
      String day = DateFormat('dd').format(date);
      String month = DateFormat('MM').format(date);
      String year = DateFormat('yyyy').format(date);
      vehicleNumber =
          vehicleNumber.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toUpperCase();
      final customerInformation = CustomerInformation(
          uid: uuid,
          contactNumber: contactNumber,
          vehicleNumber: vehicleNumber,
          vehicleRunning: vehicleRunning,
          vehicleNextRunning: vehicleNextRunning,
          receiptUrl: "",
          totalAmount: totalAmount,
          day: day,
          month: month,
          year: year);

      final uid = _ref.read(userProvider)!.uid;
      _customerFormRepository.createCustomer(uid, customerInformation);
      return right(true);
    } on FirebaseException catch (e) {
      return left(Failure(e.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void deleteCustomer(BuildContext context, String uuid) async {
    final uid = _ref.read(userProvider)!.uid;
    final result = await _customerFormRepository.deleteCustomer(uid, uuid);
    result.fold(
      (failure) => showSnackBar(context, failure.toString()),
      (success) {
        Routemaster.of(context).pop();
      },
    );
  }

  Future<String> uploadImageToFirebaseStorage(BuildContext context, String uid,
      String uuid, String path, File? image) async {
    String url = "";
    if (image != null) {
      final imageurl =
          await _customerFormRepository.uploadImageToFirebaseStorage(
              imagePath: path, uid: uid, uuid: uuid, image: image);
      imageurl.fold((l) => showSnackBar(context, l.message), (r) => url = r);
    } else {
      showSnackBar(context, AppLocalizations.of(context)!.imageNotFound);
    }
    return url;
  }

  Stream<List<CustomerInformation>> customersList() {
    final uid = _ref.read(userProvider)!.uid;
    return _customerFormRepository.customersListStream(uid);
  }

  Stream<List<CustomerInformation>> searchCustomer(String uid, String query) {
    final searchValue = _ref.watch(searchValueProvider);
    return _customerFormRepository.searchCustomer(uid, query, searchValue);
  }

  void updateCustomerdata(String uuid, String uid, String url) {
    _customerFormRepository.updateCustomerdata(uuid, uid, url);
  }

  void sendReceipt(BuildContext context, String uuid) async {
    final user = _ref.read(userProvider)!;
    final store = await _customerFormRepository.getCustomer(user.uid, uuid);

    store.fold((failure) => ErrorText(error: failure.toString()), (customer) {
      try {
        String message = '''
     🏍️ **${user.name}**
  📍 ${user.address}
  📱 Mobile: ${user.contactNumber}
  ✉ Mobile: ${user.contactNumber}

  Date: ${customer.day}/${customer.month}/${customer.year}
  Vehicle Number: ${customer.vehicleNumber}
  Vehicle Running: ${customer.vehicleRunning} km
  Total Amount: ${customer.totalAmount}
  ''';

        // Receipt : ${customer.receiptUrl}

        launchWhatsApp(customer.contactNumber, message);
      } catch (e) {
        ErrorText(error: e.toString());
      }
    });
  }

  void launchWhatsApp(String phoneNumber, String message) async {
    // Construct the WhatsApp message URL
    String whatsappUrl = "whatsapp://send?phone=+91$phoneNumber&text=$message";

    // Launch the WhatsApp message URL
    final Uri uri = Uri.parse(whatsappUrl);
    try {
      await launchUrl(uri);
    } catch (e) {
      throw "Can not share $e";
    }
  }

  void changeSearchValue(String searchValue) {
    _ref.read(searchValueProvider.notifier).state = searchValue;
  }
}
