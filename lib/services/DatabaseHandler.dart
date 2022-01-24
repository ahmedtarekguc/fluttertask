import 'package:fluttertask/helper_files/Notes.dart';
import 'package:fluttertask/helper_files/Users.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'Notes.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, noteText TEXT NOT NULL,userID INTEGER NOT NULL, dateOfInsertion TEXT NOT NULL)",
        );
        await database.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, userName TEXT NOT NULL,password TEXT NOT NULL, interest TEXT NOT NULL)",
        );
      },
      version: 1,
    );
  }

  Future<int> insertNote(Notes notes) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.insert('notes', notes.toMap());

    return result;
  }

  Future<List<Notes>> retrieveNotes() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('notes');
    return queryResult.map((e) => Notes.fromMap(e)).toList();
  }

  Future<void> deleteNote(int id) async {
    final db = await initializeDB();
    await db.delete(
      'notes',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteAllNotes(int id) async {
    final db = await initializeDB();
    await db.delete(
      'notes',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> insertUser(Users users) async {
    int result = 0;
    final Database db = await initializeDB();

    result = await db.insert('users', users.toMap());

    return result;
  }

  Future<List<Users>> retrieveUser() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('users');
    return queryResult.map((e) => Users.fromMap(e)).toList();
  }

  Future<void> deleteUsers(int id) async {
    final db = await initializeDB();
    await db.delete(
      'users',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
