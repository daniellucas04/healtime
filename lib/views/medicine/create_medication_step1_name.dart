import 'package:app/views/components/alert.dart';
import 'package:app/views/components/header.dart';
import 'package:app/views/components/form_input.dart';
import 'package:app/views/medicine/create_medication_step2_type.dart';
import 'package:app/views/theme/theme.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CreateMedicationStep1Name extends StatefulWidget {
  CreateMedicationStep1Name({
    super.key,
  });

  @override
  State<CreateMedicationStep1Name> createState() =>
      _CreateMedicationStep1NameState();
}

class _CreateMedicationStep1NameState extends State<CreateMedicationStep1Name> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  final TextEditingController medicationName = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initCamera();
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const Header(
        title: "Nome do medicamento",
        subtitle: 'Qual o nome do medicamento?',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              height: (context.heightPercentage(0.05)),
            ),
            Container(
              height: (context.heightPercentage(0.90) - 200),
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
                        label: 'Nome',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: context.heightPercentage(0.06),
                  ),
                  FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Expanded(
                          child: CameraPreview(_controller),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  FloatingActionButton(
                    // Provide an onPressed callback.
                    onPressed: () async {
                      // Take the Picture in a try / catch block. If anything goes wrong,
                      // catch the error.
                      try {
                        // Ensure that the camera is initialized.
                        await _initializeControllerFuture;

                        // Attempt to take a picture and then get the location
                        // where the image file is saved.
                        final image = await _controller.takePicture();
                        print(image.path);
                      } catch (e) {
                        // If an error occurs, log the error to the console.
                        print(e);
                      }
                    },
                    child: const Icon(Icons.camera_alt),
                  ),
                  SizedBox(
                    height: context.heightPercentage(0.06),
                  ),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (medicationName.text != "") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateMedicationStep2Type(
                                medicationName: medicationName,
                              ),
                            ),
                          );
                        } else {
                          final navigator = Navigator.of(context);
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => Alert(
                              content:
                                  const Text('Digite o nome do medicamento'),
                              title: 'Campo Inválido',
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
                      },
                      child: const Text(
                        'Próximo',
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
