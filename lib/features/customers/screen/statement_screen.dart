import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receipt_creator/core/common/appbar_title.dart';
import 'package:receipt_creator/core/common/customers_list_tile.dart';
import 'package:receipt_creator/core/common/error_text.dart';
import 'package:receipt_creator/core/common/loading.dart';
import 'package:receipt_creator/features/customers/controller/customers_controller.dart';
import 'package:receipt_creator/features/home/delegates/search_customer_delegate.dart';
import 'package:receipt_creator/l10n/app_localizations.dart';

class StatementPage extends ConsumerWidget {
  const StatementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: AppBarTitle(appbarTitleText: localization.customer)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 22.0),
            child: IconButton(
              onPressed: () {
                showSearch(
                    context: context, delegate: SearchCustomerDelegate(ref));
              },
              icon: const Icon(Icons.search_rounded),
              iconSize: 28,
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: ref.watch(customersListProvider).when(
            data: (customers) => Padding(
              padding: const EdgeInsets.all(18.0),
              child: ListView.builder(
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  return CustomerTile(
                    customer: customers[index],
                  );
                },
              ),
            ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
