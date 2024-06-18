import 'package:fl_chart/fl_chart.dart';

class DashboardData {
  final double maxCustomerCount;
  final double maxRevenue;
  final double todayCustomerCount;
  final double todayRevenue;
  final double monthCustomerCount;
  final double monthRevenue;
  final List<FlSpot> chartDataCustomerCount;
  final List<FlSpot> chartDataRevenue;
  DashboardData({
    required this.maxCustomerCount,
    required this.maxRevenue,
    required this.todayCustomerCount,
    required this.todayRevenue,
    required this.monthCustomerCount,
    required this.monthRevenue,
    required this.chartDataCustomerCount,
    required this.chartDataRevenue,
  });

  DashboardData copyWith({
    double? maxCustomerCount,
    double? maxRevenue,
    double? todayCustomerCount,
    double? todayRevenue,
    double? monthCustomerCount,
    double? monthRevenue,
    List<FlSpot>? chartDataCustomerCount,
    List<FlSpot>? chartDataRevenue,
  }) {
    return DashboardData(
      maxCustomerCount: maxCustomerCount ?? this.maxCustomerCount,
      maxRevenue: maxRevenue ?? this.maxRevenue,
      todayCustomerCount: todayCustomerCount ?? this.todayCustomerCount,
      todayRevenue: todayRevenue ?? this.todayRevenue,
      monthCustomerCount: monthCustomerCount ?? this.monthCustomerCount,
      monthRevenue: monthRevenue ?? this.monthRevenue,
      chartDataCustomerCount:
          chartDataCustomerCount ?? this.chartDataCustomerCount,
      chartDataRevenue: chartDataRevenue ?? this.chartDataRevenue,
    );
  }
}
