import 'package:app/views/medicine/create_medication_step1_name.dart';
import 'package:flutter/material.dart';

class CreateMedication extends StatelessWidget {
  const CreateMedication({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CreateMedicationStep1Name(),
      ),
    );
  }
}
