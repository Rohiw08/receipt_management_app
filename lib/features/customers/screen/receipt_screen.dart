import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receipt_creator/core/common/appbar_title.dart';
import 'package:receipt_creator/core/common/black_button.dart';
import 'package:receipt_creator/core/common/receipt_list_tile.dart';
import 'package:receipt_creator/features/customers/controller/customers_controller.dart';
import 'package:receipt_creator/features/customers/screen/view_image_screen.dart';
import 'package:receipt_creator/models/customer_info.dart';
import 'package:routemaster/routemaster.dart';
import 'package:receipt_creator/l10n/app_localizations.dart';

class ReceiptScreen extends ConsumerWidget {
  final CustomerInformation customer;
  const ReceiptScreen({super.key, required this.customer});

  Widget image(BuildContext context, String imageUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageViewScreen(imageUrl: imageUrl),
          ),
        );
      },
      child: Hero(
        tag: imageUrl,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          filterQuality: FilterQuality.high,
          progressIndicatorBuilder: (context, url, progress) => Center(
            child: CircularProgressIndicator(
              value: progress.progress,
            ),
          ),
          errorWidget: (context, url, error) =>
              Text(AppLocalizations.of(context)!.imageNotFound),
        ),
      ),
    );
  }

  void deleteCustomer(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirmDelete),
          content: Text(AppLocalizations.of(context)!
              .areYouSureYouWantToDeleteThisCustomer),
          actions: [
            TextButton(
              onPressed: () => Routemaster.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                // Delete customer logic here
                ref
                    .read(customerFormControllerProvider)
                    .deleteCustomer(context, customer.uid);
                Routemaster.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.delete),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title:
            AppBarTitle(appbarTitleText: AppLocalizations.of(context)!.receipt),
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
        actions: [
          IconButton(
              onPressed: () => deleteCustomer(context, ref),
              icon: const Icon(Icons.delete_outline_outlined))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              // backColor: whiteColor,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.customerInformation,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextWithLeadingIcon(
                      leading: const Icon(
                        Icons.calendar_month_outlined,
                        size: 20,
                      ),
                      title:
                          "${customer.day}/${customer.month}/${customer.year}",
                    ),
                    TextWithLeadingIcon(
                      leading: const Icon(
                        Icons.phone_outlined,
                        size: 20,
                      ),
                      title: customer.contactNumber,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              // backColor: Color.fromARGB(255, 242, 234, 149),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.vehicleInformation,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextWithLeadingIcon(
                      leading: const Icon(
                        Icons.directions_car,
                        size: 20,
                      ),
                      title: customer.vehicleNumber,
                    ),
                    const SizedBox(height: 5),
                    TextWithLeadingIcon(
                      leading: const Icon(
                        Icons.speed,
                        size: 20,
                      ),
                      title:
                          "${AppLocalizations.of(context)!.vehicleRunning}: ${customer.vehicleRunning} km",
                    ),
                    TextWithLeadingIcon(
                      leading: const Icon(
                        Icons.speed,
                        size: 20,
                      ),
                      title:
                          "${AppLocalizations.of(context)!.vehicleNextRunning}: ${customer.vehicleNextRunning} km",
                    ),
                    TextWithLeadingIcon(
                      leading: const Icon(
                        Icons.monetization_on,
                        size: 20,
                      ),
                      title:
                          "${AppLocalizations.of(context)!.totalAmount} ₹${customer.totalAmount.toStringAsFixed(2)}",
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.services,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Center(
                      child: image(context, customer.receiptUrl),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            MyButton(
                onTap: () {
                  ref
                      .read(customerFormControllerProvider)
                      .sendReceipt(context, customer.uid);
                },
                buttonText: AppLocalizations.of(context)!.sendReceipt),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
