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
    //initialize();
  }

  // void initialize() async {
  //   await database.initDatabase();
  //   addContactsTest();
  // }

  void addContactsTest() async {
    await database.insertContact(Contact(name: "Nikhil"));
  }

  Future<List<Contact>> asyncFetchContacts() async {
    await database.initDatabase();
    //addContactsTest();
    return await database.getContacts();
  }

  void createNewContact() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactForm(
          db: database,
          contact: Contact(
            name: "",
            phone: "",
            email: "",
            type: null,
            country: null,
          ),
        ),
      ),
    ).then((val) {
      setState(() {
        database = val;
      });
    });
  }

  void editContact(Contact selected) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactForm(
          db: database,
          contact: selected,
        ),
      ),
    ).then((val) {
      setState(() {
        database = val;
      });
    });
  }

  void deleteContact(int id) async {
    await database.deleteContact(id).then((val) {
      setState(() {});
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
                trailing: RaisedButton(
                  onPressed: () => deleteContact(snapshot.data[index].id),
                  child: Icon(Icons.delete),
                ),
                onTap: () => editContact(snapshot.data[index]),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              tooltip: 'Add',
              splashColor: Colors.blue[200],
              onPressed: createNewContact,
              child: Icon(Icons.add),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
