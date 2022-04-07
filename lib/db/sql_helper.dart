import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE localizacao(
        codLocalizacao INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        latitude REAL,
        longitude REAL,
        codUsuario TEXT,
        velocidade REAL,
        dataHoraCad TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'tracker.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> create(double latitude, double longitude,
      String codUsuario, double velocidade) async {
    final db = await SQLHelper.db();

    final data = {
      'latitude': latitude,
      'longitude': longitude,
      'codUsuario': codUsuario,
      'velocidade': velocidade
    };
    final id = await db.insert('localizacao', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAll() async {
    final db = await SQLHelper.db();
    return db.query('localizacao', orderBy: "codLocalizacao desc");
  }

  static Future<List<Map<String, dynamic>>> getById(int codLocalizacao) async {
    final db = await SQLHelper.db();
    return db.query('localizacao',
        where: "codLocalizacao = ?", whereArgs: [codLocalizacao], limit: 1);
  }

  static Future<int> update(int codLocalizacao, double latitude,
      double longitude, double velocidade) async {
    final db = await SQLHelper.db();

    final data = {
      'latitude': latitude,
      'longitude': longitude,
      'velocidade': velocidade,
    };

    final result = await db.update('localizacao', data,
        where: "codLocalizacao = ?", whereArgs: [codLocalizacao]);
    return result;
  }

  static Future<void> delete(int codLocalizacao) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("localizacao",
          where: "codLocalizacao = ?", whereArgs: [codLocalizacao]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
