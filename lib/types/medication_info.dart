final class ListObject {
  final dynamic key;
  final dynamic value;

  ListObject({
    required this.key,
    required this.value,
  });
}

List<ListObject> medicationTypes = [
  ListObject(key: 'comprimido', value: 'Comprimido'),
  ListObject(key: 'injecao', value: 'Injeção'),
  ListObject(key: 'gotas', value: 'Gotas'),
  ListObject(key: 'pomada', value: 'Pomada'),
  ListObject(key: 'inalador', value: 'Inalador'),
  ListObject(key: 'liquido', value: 'Líquido'),
];

List<ListObject> medicationFrequencyTypes = [
  ListObject(key: 'dias', value: 'Dias'),
  ListObject(key: 'horas', value: 'Horas'),
  ListObject(key: 'semanas', value: 'Semanas'),
  ListObject(key: 'vezesAoDia', value: 'Vezes ao dia'),
];
