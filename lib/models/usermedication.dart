class UserMedication {
  final int? id;
  final int userId;
  final int medicationId;

  UserMedication({this.id, required this.userId, required this.medicationId});

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'medication_id': medicationId,
    };
  }

  factory UserMedication.fromMap(Map<String, dynamic> map) {
    return UserMedication(
      userId: map['user_id'],
      medicationId: map['medication_id'],
    );
  }
}
