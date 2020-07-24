import "package:flutter/material.dart";
import "package:validators/validators.dart";
import "contacts_db.dart";
import "contact_model.dart";

class ContactForm extends StatefulWidget {
  ContactForm({Key key, this.db}) : super(key: key);

  final ContactsDatabase db;

  @override
  _ContactFormState createState() => _ContactFormState(db);
}

class _ContactFormState extends State<ContactForm> {
  _ContactFormState(this.database);

  ContactsDatabase database;
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = "--";

  String newName = "";
  String newPhone = "";
  String newEmail = "";
  String newType = "--";
  String newCountry = "";

  void saveContact() async {
    if (_formKey.currentState.validate()) {
      print("Entries are valid");
      _formKey.currentState.save();

      Contact newContact = Contact(
        name: newName,
        phone: newPhone,
        email: newEmail,
        type: newType,
        country: newCountry,
      );
      await database.insertContact(newContact);

      Navigator.pop(context, database);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Name"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: "Name"),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Name cannot be empty';
                } else if (isAlpha(value)) {
                  return null;
                }
                return "Incorrect format";
              },
              onSaved: (newValue) {
                setState(() {
                  newName = newValue;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Phone"),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (isNumeric(value)) {
                  return null;
                }
                return "Incorrect format";
              },
              onSaved: (newValue) {
                setState(() {
                  newPhone = newValue;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Email"),
              validator: (value) {
                if (isEmail(value)) {
                  return null;
                }
                return "Incorrect format";
              },
              onSaved: (newValue) {
                setState(() {
                  newEmail = newValue;
                });
              },
            ),
            DropdownButton<String>(
              value: newType,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.blue),
              onChanged: (String newValue) {
                setState(() {
                  newType = newValue;
                });
              },
              items: <String>['--', 'Home', 'Personal', 'Work']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            RaisedButton(
              child: Text("Save"),
              onPressed: saveContact,
            ),
          ],
        ),
      ),
    );
  }
}
