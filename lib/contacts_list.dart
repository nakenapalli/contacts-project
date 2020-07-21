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
  List<Contact> contacts;

  @override
  void initState() async {
    super.initState();
    database = ContactsDatabase();
    contacts = await database.getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(contacts[index].name),
        ),
      ),
    );
  }
}
