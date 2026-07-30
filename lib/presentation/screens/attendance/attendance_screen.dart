import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/models/attendance_history.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/ui_state.dart';
import '../../widgets/attendance_list_item.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_message.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/summary_card.dart';

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(attendanceProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: state.when(
        loading: () => const LoadingIndicator(),
        success: (history) => _AttendanceContent(history: history),
        error: (message) => ErrorMessage(
          message: message,
          onRetry: () => ref.read(attendanceProvider.notifier).load(),
        ),
      ),
    );
  }
}

class _AttendanceContent extends StatelessWidget {
  const _AttendanceContent({required this.history});

  final AttendanceHistory history;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = history.summary;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text(
                'Attendance Summary',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  SummaryCard(
                    value: summary.total.toString(),
                    label: 'Total',
                    color: theme.colorScheme.onSurface,
                  ),
                  const SizedBox(width: 12),
                  SummaryCard(
                    value: summary.present.toString(),
                    label: 'Present',
                    color: AppColors.success,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  SummaryCard(
                    value: summary.absent.toString(),
                    label: 'Absent',
                    color: AppColors.error,
                  ),
                  const SizedBox(width: 12),
                  SummaryCard(
                    value: summary.late.toString(),
                    label: 'Late',
                    color: AppColors.warning,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _PresentRateCard(rate: summary.presentRate),
              const SizedBox(height: 24),
              Text(
                'Records',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
            ]),
          ),
        ),
        if (history.records.isEmpty)
          const SliverFillRemaining(
            child: EmptyState(message: 'No attendance records found.', height: 200),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => AttendanceListItem(record: history.records[index]),
              childCount: history.records.length,
            ),
          ),
      ],
    );
  }
}

class _PresentRateCard extends StatelessWidget {
  const _PresentRateCard({required this.rate});

  final double rate;

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
              'Present Rate',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
