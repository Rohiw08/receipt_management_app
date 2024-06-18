import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage/features/auth/controller/auth_controller.dart';
import 'package:garage/features/dashboard/repository/dashboard_repository.dart';
import 'package:garage/models/dashboard_data.dart';

final dashboardControllerProvider = Provider((ref) => DashboardController(
      dashboardRepository: ref.watch(dashboardRepositoryProvider),
      ref: ref,
    ));

final analyzedStreamProvider =
    StreamProvider.family<DashboardData, String>((ref, date) {
  return ref.watch(dashboardControllerProvider).analysisStream(date);
});

class DashboardController {
  final DashboardRepository _dashboardRepository;
  final Ref _ref;

  DashboardController({
    required DashboardRepository dashboardRepository,
    required Ref ref,
  })  : _dashboardRepository = dashboardRepository,
        _ref = ref;

  Stream<DashboardData> analysisStream(String today) {
    final uid = _ref.read(userProvider)!.uid;
    return _dashboardRepository.analysisStream(uid, today).map((customers) {
      final filteredData = <String, List<double>>{};
      double totalMonthlyCustomerCount = 0.0;
      double totalMonthlyRevenue = 0.0;
      double totalDailyCustomerCount = 0.0;
      double totalDailyRevenue = 0.0;
      double maxCustomers = 0.0;
      double maxRevenue = 0.0;
      final customerCountSpots = <FlSpot>[];
      final revenueChartSpots = <FlSpot>[];

      for (final customer in customers) {
        final dateString = "${customer.day}/${customer.month}/${customer.year}";

        if (filteredData.containsKey(dateString)) {
          filteredData[dateString]![0]++;
          filteredData[dateString]![1] += customer.totalAmount;
        } else {
          filteredData[dateString] = [1.0, customer.totalAmount];
        }
        totalMonthlyCustomerCount += 1.0;
        totalMonthlyRevenue += customer.totalAmount;
        if (today == dateString) {
          totalDailyCustomerCount += 1.0;
          totalDailyRevenue += customer.totalAmount;
        }
      }

      for (final entry in filteredData.entries) {
        final x = double.parse(entry.key.substring(0, 2));
        maxCustomers = max(maxCustomers, entry.value[0]);
        maxRevenue = max(maxRevenue, entry.value[1]);
        customerCountSpots.add(FlSpot(x, entry.value[0]));
        revenueChartSpots.add(FlSpot(x, entry.value[1]));
      }
      return DashboardData(
        maxCustomerCount: maxCustomers,
        maxRevenue: maxRevenue,
        todayCustomerCount: totalDailyCustomerCount,
        todayRevenue: totalDailyRevenue,
        monthCustomerCount: totalMonthlyCustomerCount,
        monthRevenue: totalMonthlyRevenue,
        chartDataCustomerCount: customerCountSpots,
        chartDataRevenue: revenueChartSpots,
      );
    });
  }
}
