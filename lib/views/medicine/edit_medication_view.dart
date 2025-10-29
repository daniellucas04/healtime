import 'package:flutter/material.dart';
import 'package:app/types/medication_info.dart';
import 'package:app/controllers/medication_controller.dart';
import 'package:app/dao/medicationschedule_dao.dart';
import 'package:app/dao/user_dao.dart';
import 'package:app/dao/usermedication_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/helpers/medication_validations.dart';
import 'package:app/models/medication.dart';
import 'package:app/models/medicationschedule.dart';
import 'package:app/models/user.dart';
import 'package:app/models/usermedication.dart';
import 'package:app/views/components/alert.dart';
import 'package:app/views/components/date_time_picker.dart';
import 'package:app/views/components/form_input.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/medicine/create_medication_step3_frequency_type.dart';
import 'package:app/views/theme/theme.dart';

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

  User? usuarioVinculado; // 👤 Usuário vinculado ao medicamento

  @override
  void initState() {
    super.initState();

    // Inicializa dados do medicamento vindo da tela anterior
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
    frequencyValueInputController =
        TextEditingController(text: medicationFrequencyValue.toString());
    firstMedicationController = TextEditingController(
      text: dateHourFormat(firstMedication!),
    );

    buscarUsuarioVinculado(); // 🔍 Busca o usuário associado
  }

  Future<void> buscarUsuarioVinculado() async {
    final db = await DatabaseHelper.instance.database;
    final userMedicationDao = UserMedicationDao(database: db);
    final userDao = UserDao(database: db);

    final vinculos = await userMedicationDao.getAll();

    final vinculo = vinculos.firstWhere(
      (v) => v.medicationId == medicationId,
      orElse: () => UserMedication(userId: -1, medicationId: -1),
    );

    if (vinculo.userId != -1) {
      final user = await userDao.findById(vinculo.userId);
      if (user != null) {
        setState(() {
          usuarioVinculado = user;
        });
      }
    }
  }

  Future<void> updateMedication(context) async {
    if (!context.mounted) return;

    final navigator = Navigator.of(context);

    Medication medication = Medication(
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
              onPressed: () {
                navigator.pop();
              },
              child: const Text('OK'),
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
            onPressed: () {
              navigator.pop();
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  Future<void> _deleteMedication(context) async {
    final navigator = Navigator.of(context);

    Medication medication = Medication(
      id: medicationId,
      name: nameInputController.text,
      type: selectedType.toString(),
      frequencyType: selectedFrequencyType.toString(),
      frequencyValue: int.parse(frequencyValueInputController.text),
      duration: int.parse(durationInputController.text),
      quantity: int.parse(quantityInputController.text),
      firstMedication: firstMedication.toString(),
    );

    var deletedMedication = MedicationController().delete(medication);

    if (await deletedMedication != 0) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Alert(
        message: 'Ocorreu um erro ao excluir o medicamento',
        title: 'Erro ao Excluir',
        actions: [
          TextButton(
            onPressed: () {
              navigator.pop();
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
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
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                FormInput(
                  label: 'Nome do medicamento',
                  key: const Key('medication_name'),
                  controller: nameInputController,
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tipo de medicamento'),
                    DropdownButton(
                      value: selectedType,
                      onChanged: (Object? value) {
                        setState(() {
                          selectedType = value;
                        });
                      },
                      isExpanded: true,
                      icon: const Icon(Icons.numbers),
                      items: medicationTypes.map((item) {
                        return DropdownMenuItem(
                          value: item.key,
                          child: Text(item.value),
                        );
                      }).toList(),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                FormInput(
                  label: 'Quantidade',
                  key: const Key('medication_quantity'),
                  controller: quantityInputController,
                ),

                const SizedBox(height: 20),

                // 🧍 Mostra o nome do usuário vinculado
                if (usuarioVinculado != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.person, color: Colors.blueAccent),
                        const SizedBox(width: 8),
                        Text(
                          'Usuário: ${usuarioVinculado!.name}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),

                // 🔘 Botões de ação
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => updateMedication(context),
                    child: const Text('Editar'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.redAccent),
                    ),
                    onPressed: () {
                      final navigator = Navigator.of(context);
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => Alert(
                          message: 'Tem certeza que deseja realizar esta ação?',
                          title: 'O medicamento será excluído!',
                          actions: [
                            TextButton(
                              onPressed: () {
                                navigator.pop();
                              },
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteMedication(context);
                              },
                              child: const Text('Confirmar'),
                            )
                          ],
                        ),
                      );
                    },
                    child: const Text('Excluir'),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
