class Medication {
  final int? id;
  final String name;
  final String type;
  final String frequencyType;
  final int frequencyValue;
  final int duration;
  final int quantity;
  final String firstMedication; 

  Medication({this.id, required this.name, required this.type,  required this.frequencyType, required this.frequencyValue , required this.duration, required this.quantity, required this.firstMedication});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'frequency_type': frequencyType,
      'frequency_value': frequencyValue,
      'duration': duration,
      'quantity' : quantity,
      'first_medication': firstMedication
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'] as int?,
      name: map['name'] as String, 
      type: map['type'] as String, 
      frequencyType: map['frequency_type'] as String,
      frequencyValue: map['frequency_value'] as int, 
      duration: map['duration'] as int, 
      quantity: map['quantity'] as int, 
      firstMedication: map['first_medication'] as String,
    );
  }
}