import 'package:app/dao/medication_dao.dart';
import 'package:app/models/medication.dart';

class MedicationController {
  String? name;
  String? type;
  String? frequencyType;
  int? frequencyValue;
  int? duration;
  int? quantity;
  String? firstMedication;

  final MedicationDao medicationDao;

  MedicationController({
    required this.medicationDao,
    required this.name,
    required this.type,
    required this.frequencyType,
    required this.frequencyValue,
    required this.duration,
    required this.quantity,
    required this.firstMedication,
  });

  Future<int> save() async {
    final medication = Medication(
      id: null,
      name: name!,
      type: type!,
      frequencyType: frequencyType!,
      frequencyValue: frequencyValue!,
      duration: duration!,
      quantity: quantity!,
      firstMedication: firstMedication!,
    );

    return await medicationDao.insert(medication);
  }
}
