import 'package:app/views/components/header.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'package:app/database/database_helper.dart';
import 'package:permission_handler/permission_handler.dart';

class BackupView extends StatefulWidget {
  const BackupView({super.key});

  @override
  State<BackupView> createState() => _BackupViewState();
}

class _BackupViewState extends State<BackupView> {
  DateTime? _lastBackupDate;

  final String _backupFileName = 'healtime_backup.json';

  final List<String> _tables = [
    'users',
    'medications',
    'medicationSchedule',
    'usersMedication',
  ];

  @override
  void initState() {
    super.initState();
    _loadLastBackupDate();
  }

  Future<String?> _getPersistentBackupPath() async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      final directory = await getDownloadsDirectory();
      if (directory != null) {
        return path.join(directory.path, _backupFileName);
      }
    }

    return null;
  }

  void _loadLastBackupDate() {
    // TODO: Carregar a data do SharedPreferences.
  }

  void _saveLastBackupDate(DateTime date) {
    // TODO: Salvar a data no SharedPreferences.
  }

  Future<void> _createBackup() async {
    final backupPath = await _getPersistentBackupPath();
    if (backupPath == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Permissão de armazenamento negada ou diretório indisponível. ⛔')),
        );
      }
      return;
    }

    try {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Iniciando exportação... ⏳')),
        );
      }

      final db = await DatabaseHelper.instance.database;
      Map<String, List<Map<String, dynamic>>> backupData = {};

      for (var table in _tables) {
        final result = await db.query(table);
        backupData[table] = result;
      }

      final jsonString = json.encode(backupData);
      final backupFile = File(backupPath);
      await backupFile.writeAsString(jsonString);

      final now = DateTime.now();
      setState(() {
        _lastBackupDate = now;
      });
      _saveLastBackupDate(now);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Backup JSON criado com sucesso e salvo! ✅')),
        );
      }
    } catch (e) {
      print('Erro ao criar backup JSON: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao criar backup: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _restoreBackup() async {
    final backupPath = await _getPersistentBackupPath();
    if (backupPath == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permissão de armazenamento negada. ⛔')),
        );
      }
      return;
    }

    final backupFile = File(backupPath);

    if (!await backupFile.exists()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Nenhum arquivo de backup JSON encontrado no armazenamento externo. ❌')),
        );
      }
      return;
    }

    try {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Iniciando restauração de dados... ⏳')),
        );
      }

      final jsonString = await backupFile.readAsString();
      final Map<String, dynamic> backupData = json.decode(jsonString);

      final db = await DatabaseHelper.instance.database;

      await db.transaction((txn) async {
        for (var table in _tables.reversed) {
          await txn.delete(table);
        }

        for (var table in _tables) {
          final List<dynamic> records = backupData[table];
          for (var record in records) {
            (record as Map<String, dynamic>).remove('id');

            await txn.insert(table, record,
                conflictAlgorithm: ConflictAlgorithm.replace);
          }
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Restauração de dados concluída com sucesso! ✨')),
        );
      }
    } catch (e) {
      print('Erro ao restaurar backup JSON: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao restaurar dados: ${e.toString()}')),
        );
      }
    }
  }

  // --- Estrutura da UI ---
  @override
  Widget build(BuildContext context) {
    final String lastBackupText = _lastBackupDate == null
        ? 'Nenhum backup encontrado.'
        : 'Último Backup: ${DateFormat('dd/MM/yyyy HH:mm').format(_lastBackupDate!)}';

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
