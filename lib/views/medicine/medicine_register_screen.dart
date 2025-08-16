import 'package:flutter/material.dart';

class MedicineRegisterScreen extends StatelessWidget {
  const MedicineRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Registro'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Registro de medicamento'),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Voltar'))
          ],
        ),
      ),
    );
  }
}
