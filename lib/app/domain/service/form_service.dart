import 'package:sqflite/sqflite.dart';

import '../../data/local/database.dart';
import '../../data/model/form.dart';

class FormService {
  static Future<void> save(Form form) async {
    final db = await AppDatabase().value;
    if (form.id == null) {
      await db.insert(tableName, form.toJson());
    } else {
      await db.update(
        tableName,
        form.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
        where: 'id = ?',
        whereArgs: [form.id],
      );
    }
  }

  static Future<List<Form>> getAll() async {
    final db = await AppDatabase().value;
    final rows = await db.query(tableName);

    return List.generate(rows.length, (i) {
      return Form.fromJson(rows[i]);
    });
  }

  static const tableName = 'form';

  static const createTable = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      name VARCHAR(200) NOT NULL,
      email TEXT,
      phone_number VARCHAR(20) NOT NULL,
      date_of_birth DATE NOT NULL,
      address TEXT NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  ''';
}
