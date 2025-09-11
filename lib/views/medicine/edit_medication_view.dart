import 'package:app/helpers/medication_validations.dart';
import 'package:app/models/medication.dart';
import 'package:app/types/medication_info.dart';
import 'package:app/views/components/date_time_picker.dart';
import 'package:app/views/components/form_input.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';

class EditMedication extends StatefulWidget {
  const EditMedication({super.key, required this.medication});

  final Medication medication;
  @override
  State<EditMedication> createState() => _EditMedicationState();
}

class _EditMedicationState extends State<EditMedication> {
  late Object? selectedMedicationType = widget.medication.type;
  late Object? selectedMedicationFrequencyType =
      widget.medication.frequencyType;

  Future<void> updateMedication(context) async {
    if (!context.mounted) return;

    // TODO: Implement validation
  }

  @override
  Widget build(BuildContext context) {
    String medicationName = widget.medication.name;
    int medicationDuration = widget.medication.duration;
    int medicationQuantity = widget.medication.quantity;
    DateTime? firstMedication =
        DateTime.parse(widget.medication.firstMedication);

    final TextEditingController nameInputController =
        TextEditingController(text: medicationName);
    final TextEditingController durationInputController =
        TextEditingController(text: medicationDuration.toString());
    final TextEditingController quantityInputController =
        TextEditingController(text: medicationQuantity.toString());
    final TextEditingController firstMedicationController =
        TextEditingController(text: firstMedication.toUtc().toString());

    return Scaffold(
      appBar: Header(
        title: '${medicationName.toUpperCase()}',
        subtitle: 'Edite as informações do medicamento',
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            spacing: context.heightPercentage(0.04),
            children: [
              SizedBox(
                height: context.heightPercentage(0.05),
              ),
              FormInput(
                label: 'Nome do medicamento',
                key: const Key('medication_name'),
                controller: nameInputController,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tipo de medicamento'),
                  DropdownButton(
                    value: selectedMedicationType,
                    onChanged: (Object? value) {
                      setState(
                        () {
                          selectedMedicationType = value;
                        },
                      );
                    },
                    isExpanded: true,
                    icon: Icon(Icons.numbers),
                    items: medicationTypes.map((item) {
                      return DropdownMenuItem(
                          value: item.key, child: Text(item.value));
                    }).toList(),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tipo de frequência'),
                  DropdownButton(
                    value: selectedMedicationFrequencyType,
                    onChanged: (Object? value) {
                      setState(
                        () {
                          selectedMedicationFrequencyType = value;
                        },
                      );
                    },
                    isExpanded: true,
                    icon: Icon(Icons.calendar_month),
                    items: medicationFrequencyTypes.map((item) {
                      return DropdownMenuItem(
                          value: item.key, child: Text(item.value));
                    }).toList(),
                  )
                ],
              ),
              FormInput(
                label: 'Duração',
                key: const Key('medication_duration'),
                controller: durationInputController,
              ),
              FormInput(
                label: 'Quantidade',
                key: const Key('medication_quantity'),
                controller: quantityInputController,
              ),
              TextField(
                controller: firstMedicationController,
                readOnly: true, // Impede digitação manual
                decoration: const InputDecoration(
                  labelText: "Data e Hora",
                  border: OutlineInputBorder(),
                ),
                onTap: () async => {
                  firstMedication = await dateTimePicker(context: context),
                  if (firstMedication != null)
                    {
                      firstMedicationController.text =
                          dateFormat(firstMedication!),
                    }
                },
              ),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    updateMedication(context);
                  },
                  child: const Text('Finalizar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
