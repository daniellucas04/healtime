class UsuarioMedicamento {
  final int? id;
  final int userId;
  final int medicationId;

  UsuarioMedicamento(
      {this.id, required this.userId, required this.medicationId});

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'medication_id': medicationId,
    };
  }

  factory UsuarioMedicamento.fromMap(Map<String, dynamic> map) {
    return UsuarioMedicamento(
      userId: map['user_id'],
      medicationId: map['medication_id'],
    );
  }
}
