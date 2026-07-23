import 'package:eagle_esports/core/theme/theme.dart';
import 'package:flutter/material.dart';

class TournamentFormScheduleFields extends StatelessWidget {
  const TournamentFormScheduleFields({
    required this.registrationEndTime,
    required this.startTime,
    required this.onRegistrationChanged,
    required this.onStartChanged,
    super.key,
  });

  final DateTime? registrationEndTime;
  final DateTime? startTime;
  final ValueChanged<DateTime> onRegistrationChanged;
  final ValueChanged<DateTime> onStartChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ScheduleTile(
          label: 'Registration closes',
          value: registrationEndTime,
          onTap: () => _pickDateTime(context, onRegistrationChanged),
        ),
        const SizedBox(height: AppSpacing.md),
        _ScheduleTile(
          label: 'Tournament starts',
          value: startTime,
          onTap: () => _pickDateTime(context, onStartChanged),
        ),
      ],
    );
  }

  Future<void> _pickDateTime(
    BuildContext context,
    ValueChanged<DateTime> onChanged,
  ) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDate: now,
    );
    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
    if (time == null) return;

    onChanged(
      DateTime(date.year, date.month, date.day, time.hour, time.minute),
    );
  }
}

class _ScheduleTile extends StatelessWidget {
  const _ScheduleTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = value == null
        ? 'Select date and time'
        : MaterialLocalizations.of(context).formatFullDate(value!);

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        onTap: onTap,
        leading: const Icon(Icons.schedule, color: AppColors.electricCyan),
        title: Text(label, style: AppTextStyles.labelMd),
        subtitle: Text(text, style: AppTextStyles.bodySm),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
