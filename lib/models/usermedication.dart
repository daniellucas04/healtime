class UserMedication {
  final int? id;
  final int userId;
  final int medicationId;

  UserMedication({this.id, required this.userId, required this.medicationId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'medication_id': medicationId,
    };
  }

  factory UserMedication.fromMap(Map<String, dynamic> map) {
    return UserMedication(
        id: map['id'] as int?,
        userId: map['user_id'] as int,
        medicationId: map['medicationId'] as int);
  }
}
