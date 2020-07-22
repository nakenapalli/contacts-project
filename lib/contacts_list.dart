import 'package:contacts_project/contacts_db.dart';
import "package:flutter/material.dart";
import "contacts_db.dart";
import "contact_model.dart";

class ContactsList extends StatefulWidget {
  ContactsList({Key key}) : super(key: key);

  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  ContactsDatabase database;

  @override
  void initState() {
    super.initState();
    database = ContactsDatabase();
    initialize();
  }

  void initialize() async {
    await database.initDatabase();
    addContactsTest();
  }

  void addContactsTest() {
    database.insertContact(Contact(name: "Nikhil"));
  }

  Future<List<Contact>> asyncFetchContacts() async {
    return await database.getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: asyncFetchContacts(),
      builder: (BuildContext context, AsyncSnapshot<List<Contact>> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Contacts"),
            ),
            body: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(snapshot.data[index].name),
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
