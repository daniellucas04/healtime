import 'package:app/models/medication.dart';

class MedicationSchedule {
  final int? id;
  final String date;
  final String status;
  final int medicationId;
  final Medication? medication;

  MedicationSchedule(
      {this.id,
      required this.date,
      required this.status,
      required this.medicationId,
      this.medication});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'status': status,
      'medication_id': medicationId
    };
  }

  factory MedicationSchedule.fromMap(Map<String, dynamic> map) {
    return MedicationSchedule(
      id: map['id'] as int?,
      date: map['date'] as String,
      status: map['status'] as String,
      medicationId: map['medication_id'] as int,
    );
  }

  factory MedicationSchedule.fromMapWithMedication(Map<String, dynamic> map) {
    return MedicationSchedule(
      id: map['schedule_id'],
      date: map['date'],
      status: map['status'],
      medicationId: map['medication_id'],
      medication: Medication(
        id: map['medication_id'],
        name: map['name'],
        type: map['type'],
        frequencyType: map['frequency_type'],
        frequencyValue: map['frequency_value'],
        duration: map['duration'],
        quantity: map['quantity'],
        firstMedication: map['first_medication'],
      ),
    );
  }
}
