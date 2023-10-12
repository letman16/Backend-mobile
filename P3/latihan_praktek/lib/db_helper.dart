import 'dart:ffi';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:latihan_praktek/model/history_data.dart';
import 'package:latihan_praktek/history_screen.dart';

import 'package:latihan_praktek/model/ShoppingList.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  Database? _database;
  final String _table_name = "shopping_list";
  final String _db_name = "shoppinglist_database.db";
  final int _db_version = 2;

  DBHelper() {
    _openDB();
  }

  Future<void> _openDB() async {
    // Penghapusan database digunakan, ketika Anda sudah membuat database, dan ternyata terjadi perubahan pada table
    _database = await openDatabase(
      join(await getDatabasesPath(), _db_name),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE $_table_name (id INTEGER PRIMARY KEY, name TEXT, sum INTEGER)');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        // Handle upgrade database di sini.
        // Jika versi database telah diupgrade, Anda dapat membuat tabel "history_data" atau melakukan tindakan lain yang sesuai.
        if (oldVersion < 2) {
          db.execute(
              'CREATE TABLE history_data (id INTEGER PRIMARY KEY, id_reff INTEGER, event TEXT, date TEXT)');
        }
      },
      version: _db_version,
    );
  }

  Future<void> insertShoppingList(ShoppingList tmp) async {
    await _database?.insert('shopping_list', tmp.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ShoppingList>> getMyShoppingList() async {
    if (_database != null) {
      final List<Map<String, dynamic>> maps =
          await _database!.query('shopping_list');
      print('Isi DB Shopping List' + maps.toString());
      return List.generate(maps.length, (index) {
        return ShoppingList(
            maps[index]['id'], maps[index]['name'], maps[index]['sum']);
      });
    }
    return [];
  }

  Future<List<HistoryData>> getHistoryData() async {
    if (_database != null) {
      final List<Map<String, dynamic>> maps =
          await _database!.query('history_data');
      print('Isi DB History Data' + maps.toString());
      return List.generate(maps.length, (index) {
        return HistoryData(maps[index]['id'], maps[index]['id_reff'],
            maps[index]['event'], maps[index]['date']);
      });
    }
    return [];
  }

  Future<void> deleteShoppingList() async {
    await _database?.delete('shopping_list');
  }

  Future<void> deleteHistoryData() async {
    await _database?.delete('history_data');
  }

  Future<void> deleteShoppingListById(int id) async {
    await _database?.delete('shopping_list', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> moveToHistory(ShoppingList deletedItem) async {
    var idinsertHistory = 1;
    final historyData = HistoryData(
      deletedItem.id, // id dari item yang dihapus
      deletedItem.id, // id_ref adalah id yang sama dengan id yang dihapus
      'Deleted', // Event bisa Anda sesuaikan
      DateTime.now().toString(), // Tanggal bisa Anda sesuaikan
    );

    await _database?.insert('history_data', historyData.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> closeDB() async {
    await _database?.close();
  }
}
