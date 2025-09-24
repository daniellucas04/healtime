import 'package:app/controllers/medication_controller.dart';
import 'package:app/dao/medicationschedule_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/helpers/medication_validations.dart';
import 'package:app/models/medication.dart';
import 'package:app/models/medicationschedule.dart';
import 'package:app/types/medication_info.dart';
import 'package:app/views/components/alert.dart';
import 'package:app/views/components/date_time_picker.dart';
import 'package:app/views/components/form_input.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/medicine/create_medication_step3_frequency_type.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';

class EditMedication extends StatefulWidget {
  const EditMedication({super.key, required this.medication});

  final Medication medication;
  @override
  State<EditMedication> createState() => _EditMedicationState();
}

class _EditMedicationState extends State<EditMedication> {
  late int? medicationId;
  late String medicationName;
  late int medicationDuration;
  late int medicationQuantity;
  late int medicationFrequencyValue;
  late DateTime? firstMedication;
  late Object? selectedType;
  late Object? selectedFrequencyType;
  late TextEditingController nameInputController;
  late TextEditingController durationInputController;
  late TextEditingController quantityInputController;
  late TextEditingController frequencyValueInputController;
  late TextEditingController firstMedicationController;

  Future<void> updateMedication(context) async {
    if (!context.mounted) return;

    Medication medication = Medication(
      //TODO: Adicionar o valor da frequência na tela
      id: medicationId,
      name: nameInputController.text,
      type: selectedType.toString(),
      frequencyType: selectedFrequencyType.toString(),
      frequencyValue: int.parse(frequencyValueInputController.text),
      duration: int.parse(durationInputController.text),
      quantity: int.parse(quantityInputController.text),
      firstMedication: firstMedication.toString(),
    );

    MedicationValidations validations =
        MedicationValidations(medication: medication);

    if (validations.validate()) {
      var updatedMedication = MedicationController().update(medication);

      var interval = 0;
      var duration = medicationDuration;
      DateTime incrementDate = firstMedication!;
      DateTime finalDate =
          DateTime(incrementDate.year, incrementDate.month, incrementDate.day);
      finalDate = finalDate.add(Duration(days: duration));
      if (await updatedMedication != 0) {
        if (selectedFrequencyType == MedicationFrequencyType.dias) {
          interval = medicationFrequencyValue * 24;
        } else if (selectedFrequencyType == MedicationFrequencyType.semanas) {
          interval = medicationFrequencyValue * 168;
        } else if (selectedFrequencyType ==
            MedicationFrequencyType.vezesAoDia) {
          interval = (24 ~/ medicationFrequencyValue);
        } else {
          interval = medicationFrequencyValue;
        }

        var medicationSchedule = await MedicationScheduleDao(database: await  DatabaseHelper.instance.database).getById(medicationId!);

        int? index = medicationSchedule[0]!.id;
        var length = medicationSchedule.length;

        for(int i = 0;i < length; i++) {
          await MedicationScheduleDao(
                  database: await DatabaseHelper.instance.database)
              .update(MedicationSchedule(
                  id: index,
                  date: incrementDate.toString(),
                  status: "N",
                  medicationId: medicationId!));
          incrementDate = incrementDate.add(Duration(hours: interval));
          index = index! + 1;
        }
      }

      if (await updatedMedication != 0) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        return;
      }

      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => Alert(
          message: 'Ocorreu um erro ao atualizar o medicamento',
          title: 'Erro ao Atualizar',
          actions: [
            TextButton(
              onPressed: () {},
              child: Text('OK'),
            )
          ],
        ),
      );
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Alert(
          message: 'Dados inválidos',
          title: 'Preencha os dados corretamente',
          actions: [
            TextButton(
              onPressed: () {},
              child: Text('OK'),
            )
          ]),
    );
  }

  @override
  void initState() {
    super.initState();

    medicationId = widget.medication.id;
    medicationName = widget.medication.name;
    medicationDuration = widget.medication.duration;
    medicationQuantity = widget.medication.quantity;
    medicationFrequencyValue = widget.medication.frequencyValue;
    firstMedication = DateTime.tryParse(widget.medication.firstMedication);

    selectedType = widget.medication.type;
    selectedFrequencyType = widget.medication.frequencyType;

    nameInputController = TextEditingController(text: medicationName);
    durationInputController =
        TextEditingController(text: medicationDuration.toString());
    quantityInputController =
        TextEditingController(text: medicationQuantity.toString());
    frequencyValueInputController = TextEditingController(text: medicationFrequencyValue.toString());
    firstMedicationController =
        TextEditingController(text: dateHourFormat(firstMedication!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: medicationName.toUpperCase(),
        subtitle: 'Edite as informações do medicamento',
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(left: 24, right: 24),
            child: Column(
              spacing: context.heightPercentage(0.03),
              children: [
                const SizedBox(
                  height: 2.0,
                ),
                FormInput(
                  label: 'Nome do medicamento',
                  key: const Key('medication_name'),
                  controller: nameInputController,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tipo de medicamento'),
                    DropdownButton(
                      value: selectedType,
                      onChanged: (Object? value) {
                        setState(
                          () {
                            selectedType = value;
                          },
                        );
                      },
                      isExpanded: true,
                      icon: const Icon(Icons.numbers),
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
                    const Text('Tipo de frequência'),
                    DropdownButton(
                      value: selectedFrequencyType,
                      onChanged: (Object? value) {
                        setState(
                          () {
                            selectedFrequencyType = value;
                          },
                        );
                      },
                      isExpanded: true,
                      icon: const Icon(Icons.calendar_month),
                      items: medicationFrequencyTypes.map((item) {
                        return DropdownMenuItem(
                            value: item.key, child: Text(item.value));
                      }).toList(),
                    )
                  ],
                ),
                FormInput(
                  label: 'Valor da Frequência',
                  key: const Key('medication_frequency_value'),
                  controller: frequencyValueInputController,
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
                            dateHourFormat(firstMedication!),
                      }
                  },
                ),
                SizedBox(
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
      ),
    );
  }
}
