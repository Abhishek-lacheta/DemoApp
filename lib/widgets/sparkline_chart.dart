import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class SparklineChart extends StatelessWidget {
  const SparklineChart({
    super.key,
    required this.prices,
    required this.isPositive,
    this.height = 80,
    this.animate = true,
  });

  final List<double> prices;
  final bool isPositive;
  final double height;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    if (prices.length < 2) {
      return SizedBox(height: height);
    }

    final spots = <FlSpot>[];
    for (var i = 0; i < prices.length; i++) {
      spots.add(FlSpot(i.toDouble(), prices[i]));
    }

    final lineColor = isPositive ? AppColors.positive : AppColors.negative;

    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: spots.length.toDouble() - 1,
          lineTouchData: const LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.35,
              color: lineColor,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    lineColor.withValues(alpha: 0.35),
                    lineColor.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
        duration: animate ? const Duration(milliseconds: 400) : Duration.zero,
        curve: Curves.easeInOut,
      ),
    );
  }
}
