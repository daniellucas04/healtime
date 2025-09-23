import 'package:app/controllers/user_controller.dart';
import 'package:app/helpers/user_validation.dart';
import 'package:app/models/user.dart';
import 'package:app/views/components/alert.dart';
import 'package:app/views/components/date_time_picker.dart';
import 'package:app/views/components/form_input.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter/material.dart';

class EditPeople extends StatefulWidget{
  const EditPeople({super.key, required this.people});

  final User people;
  @override
  State<StatefulWidget> createState() => _EditPeopleState();
}

class _EditPeopleState extends State<EditPeople>{
  late int? peopleId;
  late String peopleName;
  late DateTime? peopleBirthDate;
  late TextEditingController nameInputController;
  late TextEditingController birthDateController;

  Future<void> updatePeople(context) async {
    if (!context.mounted) return;

    User user = User(
      id: peopleId,
      name: nameInputController.text, 
      birthDate: peopleBirthDate.toString(),
    );

    UserValidation validations = UserValidation(user: user);

    if(validations.validate()){
      var updatePeople = UserController().update(user);

      if(await updatePeople != 0){
        Navigator.pushNamedAndRemoveUntil(context, '/people', (route) => false);
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false, 
        builder: (context) => Alert(
          title: 'Erro ao Atualizar', 
          message: 'Ocorreu um erro ao atualizar o usuário', 
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text('OK'),
            ),
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
              child: const Text('OK'),
            )
          ]),
    );
  }

  @override
  void initState(){
    super.initState();
    peopleId = widget.people.id;
    peopleName = widget.people.name;
    peopleBirthDate = DateTime.tryParse(widget.people.birthDate);

    nameInputController = TextEditingController(text: peopleName);
    birthDateController = TextEditingController(text: dateFormat(peopleBirthDate!));

  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: peopleName.toUpperCase(),
        subtitle: 'Edite as informações do usuário',
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(left: 24, right: 24),
          child: Column(
            spacing: context.heightPercentage(0.03),
            children: [
              const SizedBox(
                height: 2.0,
              ),
              FormInput(
                label: 'Nome do usuário', 
                controller: nameInputController
              ),
              TextField(
                controller: birthDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Data Nascimento',
                  border: OutlineInputBorder(),
                ),
                onTap: () async => {
                  peopleBirthDate = await datePicker(context: context),
                  if (peopleBirthDate != null){
                    birthDateController.text = dateFormat(peopleBirthDate!),
                  }
                },
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    updatePeople(context);
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