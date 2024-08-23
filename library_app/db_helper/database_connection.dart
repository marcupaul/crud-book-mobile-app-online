import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
class DatabaseConnection{
  Future<Database>setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'books_database');
    var database =
    await openDatabase(path, version: 1, onCreate: createDatabase);
    return database;
  }
  Future<void>createDatabase(Database database, int version) async {
    String sql=
        "CREATE TABLE books (id INTEGER PRIMARY KEY, title TEXT, author TEXT, publishingDate TEXT, isbn TEXT, description TEXT, path TEXT);";
    await database.execute(sql);
  }
}