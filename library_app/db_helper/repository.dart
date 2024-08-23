import 'database_connection.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  late DatabaseConnection databaseConnection;
  Repository() {
    databaseConnection = DatabaseConnection();
  }
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await databaseConnection.setDatabase();
      return _database;
    }
  }
  insertBook(table, book) async {
    var connection = await database;
    return await connection?.insert(table, book);
  }
  readBooks(table) async {
    var connection = await database;
    return await connection?.query(table);
  }
  readBookById(table, bookId) async {
    var connection = await database;
    return await connection?.query(table, where: 'id=?', whereArgs: [bookId]);
  }
  updateBook(table, book) async {
    var connection = await database;
    return await connection?.update(table, book, where: 'id=?', whereArgs: [book['id']]);
  }
  deleteBookById(table, bookId) async {
    var connection = await database;
    return await connection?.rawDelete("delete from $table where id=$bookId");
  }
  wipeAllBooks(table) async {
    var connection = await database;
    return await connection?.rawDelete("delete from $table");
  }
}