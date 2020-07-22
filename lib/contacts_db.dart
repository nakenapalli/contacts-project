import "package:sqflite/sqflite.dart";
import "package:path/path.dart";
import "contact_model.dart";

class ContactsDatabase {
  static Database _db;

  Future<void> initDatabase() async {
    String path = join(await getDatabasesPath(), "contacts_database.db");
    print("path name: " + path);

    final Future<Database> database = openDatabase(
      path,
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

    _db = await database;
  }

  Future<List<Contact>> getContacts() async {
    final List<Map<String, dynamic>> contactsMap = await _db.query('contacts');

    return List.generate(contactsMap.length, (index) {
      return Contact(
        id: contactsMap[index]['id'],
        name: contactsMap[index]['name'],
        phone: contactsMap[index]['phone'],
        email: contactsMap[index]['email'],
        type: contactsMap[index]['type'],
        country: contactsMap[index]['country'],
      );
    });
  }

  Future<int> insertContact(Contact contact) async {
    return await _db.insert(
      'contacts',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateContact(Contact contact) async {
    return await _db.update(
      'contacts',
      contact.toMap(),
      where: "id = ?",
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(int id) async {
    return await _db.delete(
      'contacts',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
