import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receipt_creator/core/common/appbar_title.dart';
import 'package:receipt_creator/core/common/bar_chart.dart';
import 'package:receipt_creator/core/common/error_text.dart';
import 'package:receipt_creator/core/common/loading.dart';
import 'package:receipt_creator/features/auth/controller/auth_controller.dart';
import 'package:receipt_creator/features/dashboard/controller/dashboard_controller.dart';
import 'package:receipt_creator/theme/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';
import 'package:receipt_creator/l10n/app_localizations.dart';

// ignore: must_be_immutable
class DashboardScreen extends ConsumerWidget {
  DashboardScreen({super.key});

  String selectedDate = DateFormat("dd/MM/yyyy").format(DateTime.now());
  String month = DateFormat("MMMM").format(DateTime.now());

  void navigateToProfileScreen(BuildContext context) {
    Routemaster.of(context).push("/profile-Screen");
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime date = DateFormat("dd/MM/yyyy").parse(selectedDate);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime.now(),
    );
    final pickedDate = DateFormat("dd/MM/yyyy").format(picked!);
    month = DateFormat("MMMM").format(picked);
    if (pickedDate.isNotEmpty && pickedDate != selectedDate) {
      selectedDate = pickedDate;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(userProvider)!.name;
    return ref.watch(analyzedStreamProvider(selectedDate)).when(
          data: (analyzedData) => Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: themeColor(context),
                          child: Text(
                            userName[0].toUpperCase(),
                            style: const TextStyle(fontSize: 25),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.hello,
                              // AppLocalizations.of(context)!.hello,
                              style: GoogleFonts.lato(
                                  fontSize: 16,
                                  letterSpacing: 0.8,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.blueGrey),
                            ),
                            Text(
                              userName,
                              style: GoogleFonts.lato(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            )
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: IconButton(
                            onPressed: () => navigateToProfileScreen(context),
                            icon: const Icon(Icons.settings_outlined),
                            iconSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Spacer(),
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(width: 1),
                                      color: Colors.black,
                                    ),
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        shape: const BeveledRectangleBorder(),
                                      ),
                                      label: Text(
                                        selectedDate
                                            .toString()
                                            .substring(0, 10),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      onPressed: () {
                                        selectDate(context);
                                      },
                                      // selectDate(context),
                                      icon: const Icon(
                                        Icons.date_range_rounded,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: SizedBox(
                            height: 90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ShowDigitTile(
                                  title: AppLocalizations.of(context)!.revenue,
                                  // AppLocalizations.of(context)!.revenue,
                                  amount: analyzedData.todayRevenue,
                                ),
                                // selectedDayRevenue.toStringAsFixed(2)),
                                const SizedBox(
                                  width: 5,
                                ),
                                ShowDigitTile(
                                  title: AppLocalizations.of(context)!
                                      .customerCount,
                                  // AppLocalizations.of(context)!.customerCount,

                                  amount:
                                      analyzedData.todayCustomerCount.floor(),
                                )
                              ],
                            ),
                          ),
                        ),
                        chartTitle(month),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: SizedBox(
                            height: 90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ShowDigitTile(
                                  title: AppLocalizations.of(context)!.revenue,
                                  // AppLocalizations.of(context)!.revenue,
                                  amount: analyzedData.monthRevenue,
                                ),
                                // selectedDayRevenue.toStringAsFixed(2)),
                                const SizedBox(
                                  width: 5,
                                ),
                                ShowDigitTile(
                                  title: AppLocalizations.of(context)!
                                      .customerCount,
                                  // AppLocalizations.of(context)!.customerCount,
                                  amount:
                                      analyzedData.monthCustomerCount.floor(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        chartTitle(AppLocalizations.of(context)!.customerCount),
                        SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: BChart(
                              xAxisTitle: AppLocalizations.of(context)!.date,
                              yAxisTitle:
                                  AppLocalizations.of(context)!.customerCount,
                              flSpotList: analyzedData.chartDataCustomerCount,
                              yMax: analyzedData.maxCustomerCount,
                              ifListIsEmpty:
                                  "${AppLocalizations.of(context)!.noData} $month",
                            )),
                        chartTitle(AppLocalizations.of(context)!.revenue),
                        SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: BChart(
                              xAxisTitle: AppLocalizations.of(context)!.date,
                              yAxisTitle: AppLocalizations.of(context)!.revenue,
                              flSpotList: analyzedData.chartDataRevenue,
                              yMax: analyzedData.maxRevenue,
                              ifListIsEmpty:
                                  "${AppLocalizations.of(context)!.noData} $month",
                            )),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}

Row chartTitle(String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(18.0),
        child: AppBarTitle(appbarTitleText: title),
      ),
    ],
  );
}

class ShowDigitTile extends StatelessWidget {
  final String title;
  final dynamic amount;
  const ShowDigitTile({super.key, required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title),
          Text(
            amount.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
