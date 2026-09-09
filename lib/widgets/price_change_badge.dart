import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../utils/price_formatter.dart';

class PriceChangeBadge extends StatelessWidget {
  const PriceChangeBadge({
    super.key,
    required this.percent,
    this.compact = false,
  });

  final double percent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isPositive = percent >= 0;
    final color = isPositive ? AppColors.positive : AppColors.negative;
    final icon = isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: compact ? 18 : 20),
          Text(
            PriceFormatter.formatPercent(percent),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: compact ? 12 : 13,
            ),
          ),
        ],
      ),
    );
  }
}
