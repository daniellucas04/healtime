enum MedicationType {
  comprimido,
  injecao,
  gotas,
  pomada,
  inalador,
  liquido,
}

extension MedicationTypeExtension on MedicationType {
  String get displayName {
    switch (this) {
      case MedicationType.comprimido:
        return 'Comprimido';
      case MedicationType.injecao:
        return 'Injeção';
      case MedicationType.gotas:
        return 'Gotas';
      case MedicationType.pomada:
        return 'Pomada';
      case MedicationType.inalador:
        return 'Inalador';
      case MedicationType.liquido:
        return 'Líquido';
    }
  }
}
