import 'package:app/models/medication.dart';

class MedicationValidations {
  final Medication medication;

  MedicationValidations({required this.medication});

  bool validate() {
    if (medication.name == '') {
      return false;
    }

    if (medication.type == '') {
      return false;
    }

    if (medication.frequencyType == '') {
      return false;
    }

    if (medication.frequencyValue <= 0) {
      return false;
    }

    if (medication.duration <= 0) {
      return false;
    }

    if (medication.quantity <= 0) {
      return false;
    }

    if (medication.firstMedication == '') {
      return false;
    }

    return true;
  }
}
