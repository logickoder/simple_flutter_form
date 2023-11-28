import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../domain/service/form_service.dart';

class AppDatabase {
  static final AppDatabase _singleton = AppDatabase._internal();
  static const name = 'forms.db';

  Database? _database;

  factory AppDatabase() {
    return _singleton;
  }

  AppDatabase._internal();

  Future<void> _ensureInitialized() async {
    if (_database != null) {
      return;
    }

    // open the database
    final path = join(await getDatabasesPath(), name);
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute(FormService.createTable);
      },
    );
  }

  Future<Database> get value async {
    if (_database == null) {
      await _ensureInitialized();
    }
    return _database!;
  }
}
