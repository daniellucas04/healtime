import 'package:app/views/components/alert.dart';
import 'package:app/views/components/create_header.dart';
import 'package:app/views/components/form_input.dart';
import 'package:app/views/medicine/create_medication_step2_type.dart';
import 'package:flutter/material.dart';

class CreateMedicationStep1Name extends StatelessWidget {
  CreateMedicationStep1Name({super.key,});

  final TextEditingController medicationName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const CreateHeader(
                icon: Icon(
                  Icons.medication,
                  size: 65,
                ),
                title: "Adicione informações sobre o medicamento",
              ),
              const SizedBox(
                height: 60,
              ),
              Container(
                height: 400,
                margin: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      spacing: 36,
                      children: [
                        FormInput(
                          controller: medicationName,
                          key: const Key('medication_name'),
                          icon: const Icon(
                            Icons.search,
                          ),
                          label: 'Nome',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if(medicationName.text != ""){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => CreateMedicationStep2Type(medicationName: medicationName)));
                          }else{
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false, 
                              builder: (context) => const Alert(
                                message: 'Digite o nome do medicamento',
                                title: 'Campo Invalido',
                              ),
                            );
                          }
                        },
                        child: const Text('Próximo'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
