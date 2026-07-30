import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/models/student_summary.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/ui_state.dart';
import '../../widgets/attendance_list_item.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_message.dart';
import '../../widgets/kpi_card.dart';
import '../../widgets/loading_indicator.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Scholaris'),
            Text(
              DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.onPrimary.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
      body: state.when(
        loading: () => const LoadingIndicator(),
        success: (summary) => _DashboardContent(summary: summary),
        error: (message) => ErrorMessage(
          message: message,
          onRetry: () => ref.read(dashboardProvider.notifier).load(),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.summary});

  final StudentSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                summary.fullName,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: _ScanCard()),
          const SizedBox(height: 24),
          Text(
            'Overview',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              KpiCard(value: summary.classCount.toString(), label: 'Classes'),
              const SizedBox(width: 12),
              KpiCard(value: summary.scheduleCount.toString(), label: 'Schedules'),
            ],
          ),
          const SizedBox(height: 12),
          _PresentRateCard(
            rate: summary.attendancePresentRate,
            total: summary.attendanceTotal,
          ),
          const SizedBox(height: 24),
          Text(
            'Recent Attendance',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (summary.recentAttendance.isEmpty)
            const EmptyState(message: 'No recent attendance records.', height: 200)
          else
            ...summary.recentAttendance.take(5).map(
              (record) => AttendanceListItem(record: record),
            ),
        ],
      ),
    );
  }
}

class _ScanCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scan QR to check in',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Point your camera at the teacher's QR code.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onPrimary.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PresentRateCard extends StatelessWidget {
  const _PresentRateCard({required this.rate, required this.total});

  final double rate;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              '${rate.toInt()}%',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Present rate across $total records',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: (rate / 100).clamp(0, 1).toDouble(),
              backgroundColor: theme.colorScheme.surfaceVariant,
              color: AppColors.primary,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}
