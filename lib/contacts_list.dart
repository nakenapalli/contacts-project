import 'package:contacts_project/contacts_db.dart';
import "package:flutter/material.dart";
import "contacts_db.dart";
import "contact_model.dart";
import "contact_form.dart";

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

  void createNewContact() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactForm(db: database),
      ),
    ).then((val) {
      database = val;
    });
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
            floatingActionButton: FloatingActionButton(
              tooltip: 'Add',
              splashColor: Colors.blue[200],
              onPressed: createNewContact,
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
