import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:garage/core/common/appbar_title.dart';
import 'package:garage/core/common/black_button.dart';
import 'package:garage/core/common/text_fields/input_text_field.dart';
import 'package:garage/core/utils.dart';
import 'package:garage/features/customers/controller/customers_controller.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

class CustomerForm extends ConsumerStatefulWidget {
  const CustomerForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomerFormState();
}

class _CustomerFormState extends ConsumerState<CustomerForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController vehicleRunningController = TextEditingController();
  TextEditingController vehicleNextRunningController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();

  void createCustomer(
      BuildContext context,
      String phoneNumber,
      String vehicleNumber,
      double vehicleRunning,
      double vehicleNextRunning,
      double totalAmount,
      String uuid) {
    ref.read(customerFormControllerProvider).createCustomer(
          uuid,
          phoneNumber,
          vehicleNumber,
          vehicleRunning,
          vehicleNextRunning,
          totalAmount,
          context,
        );
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    vehicleNumberController.dispose();
    vehicleRunningController.dispose();
    vehicleNextRunningController.dispose();
    totalAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization =
        AppLocalizations.of(context)!; // Access localization instance

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(
          appbarTitleText: localization.customerForm, // Use localization key
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => Routemaster.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFieldCard(
                    nameController: phoneNumberController,
                    hintText: localization.contactNumber,
                    textInputType: TextInputType.number, // Use localization key
                  ),
                  TextFieldCard(
                    nameController: vehicleNumberController,
                    hintText: localization.vehicleNumber,
                    textInputType: TextInputType.text, // Use localization key
                  ),
                  TextFieldCard(
                    nameController: vehicleRunningController,
                    hintText: localization.vehicleRunning,
                    textInputType: TextInputType.number, // Use localization key
                  ),
                  TextFieldCard(
                    nameController: vehicleNextRunningController,
                    hintText: localization.vehicleNextRunning,
                    textInputType: TextInputType.number, // Use localization key
                  ),
                  TextFieldCard(
                    nameController: totalAmountController,
                    hintText: localization.totalAmount,
                    textInputType: TextInputType.number, // Use localization key
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  MyButton(
                    onTap: () {
                      final uuid = const Uuid().v4();
                      try {
                        if (phoneNumberController.text.isEmpty ||
                            vehicleNumberController.text.isEmpty ||
                            vehicleNextRunningController.text.isEmpty ||
                            vehicleRunningController.text.isEmpty ||
                            totalAmountController.text.isEmpty) {
                          throw "Fill all information";
                        }
                        createCustomer(
                          context,
                          phoneNumberController.text,
                          vehicleNumberController.text,
                          double.parse(vehicleRunningController.text),
                          double.parse(vehicleNextRunningController.text),
                          double.parse(totalAmountController.text),
                          uuid,
                        );
                        Routemaster.of(context).push("/image-picker/$uuid");
                      } catch (e) {
                        showSnackBar(context, e.toString());
                      }
                    },
                    buttonText: localization.addService, // Use localization key
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
