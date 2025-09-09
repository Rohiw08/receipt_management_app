import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:receipt_creator/core/common/appbar_title.dart';
import 'package:receipt_creator/core/common/black_button.dart';
import 'package:receipt_creator/core/common/loading.dart';
import 'package:receipt_creator/core/failure.dart';
import 'package:receipt_creator/core/typedef.dart';
import 'package:receipt_creator/core/utils.dart';
import 'package:receipt_creator/features/auth/controller/auth_controller.dart';
import 'package:receipt_creator/features/customers/controller/customers_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:routemaster/routemaster.dart';
import 'package:receipt_creator/l10n/app_localizations.dart';

class ImagePickerScreen extends ConsumerStatefulWidget {
  final String uuid;
  const ImagePickerScreen({super.key, required this.uuid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ImagePickerScreenState();
}

class _ImagePickerScreenState extends ConsumerState<ImagePickerScreen> {
  File? image;
  bool isLoading = false;

  FutureEither<String> pickImgFromCamera() async {
    try {
      final pickedImage = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 10);

      if (pickedImage != null) {
        setState(() {
          image = File(pickedImage.path);
        });
      }
      return Right(pickedImage?.path ?? '');
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<void> uploadImage(String uid) async {
    try {
      setState(() {
        isLoading = true;
      });

      final String url = await ref
          .read(customerFormControllerProvider)
          .uploadImageToFirebaseStorage(
              context, uid, widget.uuid, 'receipt/', image!);

      ref
          .read(customerFormControllerProvider)
          .updateCustomerdata(widget.uuid, uid, url);

      setState(() {
        isLoading = false;
        // Routemaster.of(context).replace("/");
      });
      sendReceipt(widget.uuid);
    } catch (e) {
      setState(() {
        isLoading = false;
        showSnackBar(context, "Some error occured");
      });
    }
  }

  void sendReceipt(String uuid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Send receipt'),
          content:
              const Text('This action will share the receipt via WhatsApp'),
          actions: [
            TextButton(
              onPressed: () => Routemaster.of(context).replace("/"),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Routemaster.of(context).replace("/");
                ref
                    .read(customerFormControllerProvider)
                    .sendReceipt(context, uuid);
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = ref.read(userProvider)!.uid;
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(appbarTitleText: localization.uploadReceipt),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () {
              Routemaster.of(context).pop();
            },
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: Loader())
          : Padding(
              padding: const EdgeInsets.all(18.0),
              child: Center(
                child: GestureDetector(
                  onTap: () => pickImgFromCamera(),
                  child: ListView(
                    children: [
                      Container(
                        height: 450,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(15)),
                        child: image != null
                            ? Image.file(image!)
                            : const Icon(Icons.camera_alt_outlined),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      MyButton(
                        onTap: () {
                          uploadImage(uid);
                        },
                        buttonText: localization.addService,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
