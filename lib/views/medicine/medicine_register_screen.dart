import 'package:flutter/material.dart';

class MedicineRegisterScreen extends StatelessWidget {
  const MedicineRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Registro de medicamento'),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Voltar'))
          ],
        ),
      ),
    );
  }
}
