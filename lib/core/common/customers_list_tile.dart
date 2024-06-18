import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:garage/theme/theme.dart';
import 'package:garage/features/customers/screen/receipt_screen.dart';
import 'package:garage/models/customer_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomerTile extends ConsumerWidget {
  final CustomerInformation customer;
  const CustomerTile({super.key, required this.customer});

  void naviagteToReceipt(BuildContext context, CustomerInformation customer) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ReceiptScreen(customer: customer)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          onTap: () {
            naviagteToReceipt(context, customer);
          },
          leading: Container(
            width: 5,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: themeColor(context)),
          ),
          title: Text(
            customer.contactNumber,
            style: GoogleFonts.lato(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          subtitle: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall,
              children: <TextSpan>[
                TextSpan(
                  text: '${AppLocalizations.of(context)!.vehicleNumber} : ',
                ),
                TextSpan(
                  text: customer.vehicleNumber,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹ ${customer.totalAmount.toStringAsFixed(2)}',
                style: GoogleFonts.varelaRound(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                ("${customer.day}/${customer.month}/${customer.year}")
                    .toString()
                    .substring(0, 10),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
