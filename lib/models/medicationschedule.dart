class MedicationSchedule {
  final int? id;
  final String date;
  final String status;
  final int medicationId;

  MedicationSchedule(
      {this.id,
      required this.date,
      required this.status,
      required this.medicationId});

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
}
