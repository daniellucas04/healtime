import 'package:flutter/material.dart';
import 'package:app/models/medication_type.dart';

class MedicationTypeItem extends StatelessWidget {
  final MedicationType type;
  final VoidCallback onTap;
  final Icon icon;
  final bool showDivider;

  const MedicationTypeItem({
    super.key,
    required this.type,
    required this.icon,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: onTap,
            splashColor:
                Theme.of(context).primaryColorLight.withValues(alpha: 0.5),
            highlightColor:
                Theme.of(context).primaryColorLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: icon,
              title: Text(type.displayName),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ),
        )
      ],
    );
  }
}
