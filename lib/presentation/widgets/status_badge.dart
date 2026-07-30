import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.status, super.key});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (textColor, bgColor) = _resolveColors(status, context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  (Color, Color) _resolveColors(String status, BuildContext context) {
    switch (status.toLowerCase()) {
      case 'present':
        return (AppColors.success, AppColors.successLight);
      case 'absent':
        return (AppColors.error, AppColors.errorLight);
      case 'late':
        return (AppColors.warning, AppColors.warningLight);
      default:
        return (
          Theme.of(context).colorScheme.onSurfaceVariant,
          Theme.of(context).colorScheme.surfaceVariant,
        );
    }
  }
}
