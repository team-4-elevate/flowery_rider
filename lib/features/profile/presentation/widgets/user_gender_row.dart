import 'package:flutter/material.dart';

class UserGenderRow extends StatelessWidget {
  final String value;
  final String label;
  final bool isSelected;
  final Color fillColor;
  const UserGenderRow({
    super.key,
    required this.value,
    required this.label,
    required this.isSelected,
    required this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: value,
            groupValue: isSelected ? value : null,
            fillColor: WidgetStatePropertyAll(fillColor),
            onChanged: (v) {},
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
    );
  }
}
