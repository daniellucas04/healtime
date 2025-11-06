import 'package:app/views/components/header.dart';
import 'package:flutter/material.dart';

class BackupView extends StatefulWidget {
  const BackupView({super.key});

  @override
  State<BackupView> createState() => _BackupViewState();
}

class _BackupViewState extends State<BackupView> {
  DateTime? _lastBackupDate;

  @override
  void initState() {
    super.initState();
    // _loadLastBackupDate();
  }

  void _createBackup() {
    setState(() {
      _lastBackupDate = DateTime.now();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Backup criado com sucesso!')),
    );
  }

  void _restoreBackup() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Iniciando restauração...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String lastBackupText = _lastBackupDate == null
        ? 'Nenhum backup encontrado.'
        : 'Último Backup: ';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Header(title: 'Backup de Dados'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  lastBackupText,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _createBackup,
              icon: const Icon(Icons.cloud_upload),
              label: const Text('GERAR NOVO BACKUP',
                  style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: _restoreBackup,
              icon: const Icon(Icons.cloud_download),
              label: const Text('RESTAURAR BACKUP',
                  style: TextStyle(fontSize: 18)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
