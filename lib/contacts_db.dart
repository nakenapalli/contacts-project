import "package:sqflite/sqflite.dart";
import "package:path/path.dart";

class ContactsDatabase {
  Future<Database> initDatabase() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), "contacts_database.db"),
      version: 1,
      onCreate: (db, version) {
        db.execute(
          '''
          CREATE TABLE contacts(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            phone TEXT,
            email TEXT,
            type TEXT,
            country TEXT)
          ''',
        );
      },
    );

    return database;
  }
}
