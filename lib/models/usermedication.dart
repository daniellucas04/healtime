class UsuarioMedicamento {
  final int usuarioId;
  final int medicamentoId;

  UsuarioMedicamento({required this.usuarioId, required this.medicamentoId});

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
