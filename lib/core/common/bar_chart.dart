import 'dart:math';

import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

import 'package:receipt_creator/theme/theme.dart';

class BChart extends StatefulWidget {
  const BChart(
      {super.key,
      required this.xAxisTitle,
      required this.yAxisTitle,
      required this.flSpotList,
      required this.yMax,
      required this.ifListIsEmpty});
  final String ifListIsEmpty;
  final String xAxisTitle;
  final String yAxisTitle;
  final double yMax;
  final List<FlSpot> flSpotList;

  @override
  State<BChart> createState() => _BChartState();
}

class _BChartState extends State<BChart> {
  var color = const LinearGradient(
    colors: [
      Colors.lightBlue,
      Colors.blue,
      Colors.indigo,
    ],
  );

  var bottomColor = const LinearGradient(
    colors: [
      Color.fromARGB(130, 3, 168, 244),
      Color.fromARGB(130, 38, 100, 150),
      Color.fromARGB(130, 2, 53, 94),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: widget.flSpotList.isEmpty
          ? SizedBox(
              height: 300,
              width: 300,
              child: Center(
                child: Text(widget.ifListIsEmpty),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    widget.yAxisTitle,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SizedBox(
                      height: 300,
                      // Calculate dynamic width based on bars and available space
                      width: (widget.flSpotList.length * 60.0) +
                          70, // Adjusted width
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: BarChart(
                          BarChartData(
                            baselineY: 0,
                            minY: 0,
                            maxY: max(5, widget.yMax),
                            barTouchData: BarTouchData(),
                            gridData: const FlGridData(show: false),
                            titlesData: FlTitlesData(
                              show: true,
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) {
                                    // Display only whole numbers on the left side
                                    return Text(value.floor().toString());
                                  },
                                  reservedSize: 45,
                                ),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            groupsSpace: 0,
                            barGroups: widget.flSpotList
                                .map(
                                  (spot) => BarChartGroupData(
                                    x: spot.x
                                        .toInt(), // Use x.toInt() to get the integer part
                                    barRods: [
                                      BarChartRodData(
                                        toY: spot.y,
                                        width: 25, // Adjust bar width as needed
                                        color: themeColor(context),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    widget.xAxisTitle,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
    );
  }
}
