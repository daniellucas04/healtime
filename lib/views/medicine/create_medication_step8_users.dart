import 'package:app/controllers/medication_controller.dart';
import 'package:app/dao/medicationschedule_dao.dart';
import 'package:app/database/database_helper.dart';
import 'package:app/models/medication.dart';
import 'package:app/models/medicationschedule.dart';
import 'package:app/views/components/alert.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/components/date_time_picker.dart';
import 'package:app/views/medicine/create_medication_step2_type.dart';
import 'package:app/views/medicine/create_medication_step3_frequency_type.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:app/dao/user_dao.dart';
import 'package:app/models/usermedication.dart';
import 'package:app/models/user.dart';

class CreateMedicationStep8UserMedication extends StatelessWidget {
  CreateMedicationStep8UserMedication({
    super.key,
    required this.medicationName,
    required this.medicationType,
    required this.medicationFrequencyType,
    required this.medicationFrequencyValue,
    required this.medicationQuantity,
    required this.medicationDuration,
  });

  final TextEditingController medicationName;
  final MedicationType medicationType;
  final MedicationFrequencyType medicationFrequencyType;
  final TextEditingController medicationFrequencyValue;
  final TextEditingController medicationDuration;
  final TextEditingController medicationQuantity;

  Future<List<User>> _getUsersWithDefault() async {
    var users = await UserDao(database: await DatabaseHelper.instance.database)
        .getAll();

    if (users.isEmpty) {
      UserDao(database: await DatabaseHelper.instance.database).insert(User(
          name: 'Você', birthDate: DateTime(2000, 1, 1).toString(), active: 1));
    }

    users = await UserDao(database: await DatabaseHelper.instance.database)
        .getAll();

    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: 'Usuário',
        subtitle: 'O remédio vai ser para qual usuário?',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: context.heightPercentage(0.05)),
            Container(
              height: context.heightPercentage(0.90) - 200,
              margin: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                children: [
                  // Selecione o usuário
                  DropdownButton<User>(
                    onChanged: (User? user) {
                      if (user != null) {
                        // Salve o vínculo entre o usuário e o medicamento
                        final userMedication = UsuarioMedicamento(
                          usuarioId: user.id!,
                          medicamentoId:
                              medicationId, // ID do medicamento cadastrado
                        );

                        // Agora, insira esse vínculo no banco de dados
                        MedicationController()
                            .linkMedicationToUser(userMedication);
                      }
                    },
                    items: users.map((user) {
                      return DropdownMenuItem<User>(
                        value: user,
                        child: Text(user.name),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 45),
                  ElevatedButton(
                    onPressed: () {
                      // Finalize o processo de cadastro
                    },
                    child: const Text('Finalizar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
