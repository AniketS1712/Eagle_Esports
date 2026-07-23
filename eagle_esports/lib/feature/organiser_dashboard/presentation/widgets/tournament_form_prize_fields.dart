import 'package:eagle_esports/core/theme/theme.dart';
import 'package:flutter/material.dart';

class TournamentFormPrizeFields extends StatefulWidget {
  const TournamentFormPrizeFields({required this.onChanged, super.key});
  final void Function(Map<String, dynamic> distribution, double totalPool)
  onChanged;

  @override
  State<TournamentFormPrizeFields> createState() =>
      _TournamentFormPrizeFieldsState();
}

class _TournamentFormPrizeFieldsState extends State<TournamentFormPrizeFields> {
  final _rank1Controller = TextEditingController();
  final _rank2Controller = TextEditingController();
  final _rank3Controller = TextEditingController();

  double get _total {
    final r1 = double.tryParse(_rank1Controller.text.trim()) ?? 0;
    final r2 = double.tryParse(_rank2Controller.text.trim()) ?? 0;
    final r3 = double.tryParse(_rank3Controller.text.trim()) ?? 0;
    return r1 + r2 + r3;
  }

  void _emit() {
    final distribution = <String, dynamic>{
      if (_rank1Controller.text.trim().isNotEmpty)
        '1': double.tryParse(_rank1Controller.text.trim()) ?? 0,
      if (_rank2Controller.text.trim().isNotEmpty)
        '2': double.tryParse(_rank2Controller.text.trim()) ?? 0,
      if (_rank3Controller.text.trim().isNotEmpty)
        '3': double.tryParse(_rank3Controller.text.trim()) ?? 0,
    };
    widget.onChanged(distribution, _total);
  }

  @override
  void dispose() {
    _rank1Controller.dispose();
    _rank2Controller.dispose();
    _rank3Controller.dispose();
    super.dispose();
  }

  Widget _rankField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label, prefixText: 'Talons '),
        onChanged: (_) => setState(_emit),
        validator: (v) {
          if (v == null || v.trim().isEmpty) return null;
          final parsed = double.tryParse(v.trim());
          if (parsed == null || parsed < 0) return 'Enter a valid amount';
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Prize Distribution', style: AppTextStyles.labelMd),
        const SizedBox(height: AppSpacing.sm),
        _rankField('1st Place', _rank1Controller),
        _rankField('2nd Place', _rank2Controller),
        _rankField('3rd Place', _rank3Controller),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Text('Total Prize Pool: ', style: AppTextStyles.bodyMd),
            Text(
              '${_total.toStringAsFixed(0)} Talons',
              style: AppTextStyles.numberMd.copyWith(
                color: AppColors.statusSuccess,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
