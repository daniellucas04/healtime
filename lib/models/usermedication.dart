class UserMedication {
  final int? id;
  final int userId;
  final int medicationId;

  UserMedication({this.id, required this.userId, required this.medicationId});

  Map<String, dynamic> toMap() {
    return {
      'user_id': usuarioId,
      'medication_id': medicamentoId,
    };
  }

  factory UsuarioMedicamento.fromMap(Map<String, dynamic> map) {
    return UsuarioMedicamento(
      usuarioId: map['user_id'],
      medicamentoId: map['medication_id'],
    );
  }
}
