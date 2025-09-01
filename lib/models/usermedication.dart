class UsuarioMedicamento {
  final int usuarioId;
  final int medicamentoId;

  UsuarioMedicamento({required this.usuarioId, required this.medicamentoId});

  Map<String, dynamic> toMap() {
    return {
      'usuario_id': usuarioId,
      'medicamento_id': medicamentoId,
    };
  }

  factory UsuarioMedicamento.fromMap(Map<String, dynamic> map) {
    return UsuarioMedicamento(
      usuarioId: map['usuario_id'],
      medicamentoId: map['medicamento_id'],
    );
  }
}
