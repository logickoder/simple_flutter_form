import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/local/database.dart';
import '../../data/model/form.dart';
import 'auth_service.dart';

class FormService {
  static Future<void> save(Form form) async {
    final db = await AppDatabase().value;
    var id = form.id;

    if (id == null) {
      id = await db.insert(tableName, form.toJson());
    } else {
      await db.update(
        tableName,
        form.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    // save to firebase
    await FirebaseFirestore.instance
        .collection(AuthService.userId)
        .doc(id.toString())
        .set(form.toJson());
  }

  static Future<void> delete(int id) async {
    final db = await AppDatabase().value;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    // delete from firebase
    await FirebaseFirestore.instance
        .collection(AuthService.userId)
        .doc(id.toString())
        .delete();
  }

  static Future<List<Form>> getAll() async {
    final db = await AppDatabase().value;
    final rows = await db.query(tableName);

    return List.generate(rows.length, (i) {
      return Form.fromJson(rows[i]);
    });
  }

  /// retrieves all forms from the remote database and stores them locally
  static Future<void> getFromFirebase() async {
    final collection = FirebaseFirestore.instance.collection(
      AuthService.userId,
    );
    final snapshot = await collection.get();

    final items = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = int.parse(doc.id);
      return Form.fromJson(data);
    }).toList();

    final db = await AppDatabase().value;
    await db.delete(tableName);
    for (final item in items) {
      await db.insert(tableName, item.toJson());
    }
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
