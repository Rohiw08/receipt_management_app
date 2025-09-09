import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receipt_creator/core/common/customers_list_tile.dart';
import 'package:receipt_creator/core/common/error_text.dart';
import 'package:receipt_creator/core/common/loading.dart';
import 'package:receipt_creator/core/enums/enums.dart';
import 'package:receipt_creator/features/customers/controller/customers_controller.dart';
import 'package:routemaster/routemaster.dart';
import 'package:receipt_creator/l10n/app_localizations.dart';

class SearchCustomerDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchCustomerDelegate(this.ref);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      PopupMenuButton<SearchOptions>(
        onSelected: (SearchOptions item) {
          ref.read(searchValueProvider.notifier).state = item.name;
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<SearchOptions>>[
          PopupMenuItem<SearchOptions>(
            value: SearchOptions.contactNumber,
            child: ListTile(
              leading: const Icon(Icons.phone),
              title: Text(AppLocalizations.of(context)!.contactNumber),
            ),
          ),
          PopupMenuItem<SearchOptions>(
            value: SearchOptions.vehicleNumber,
            child: ListTile(
              leading: const Icon(Icons.motorcycle_sharp),
              title: Text(AppLocalizations.of(context)!.vehicleNumber),
            ),
          ),
        ],
        icon: const Icon(Icons.filter_alt_outlined),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Routemaster.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back_outlined));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchCustomerProvider(query.toUpperCase())).when(
          data: (customers) => Padding(
            padding: const EdgeInsets.all(18.0),
            child: ListView.builder(
              itemCount: customers.length,
              itemBuilder: (BuildContext context, int index) {
                final customer = customers[index];
                return CustomerTile(customer: customer);
              },
            ),
          ),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
