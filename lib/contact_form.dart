import "package:flutter/material.dart";
import "package:validators/validators.dart";
import "package:validators/sanitizers.dart";
import "contacts_db.dart";
import "contact_model.dart";
import 'countries_api.dart' as api;
import 'country_model.dart';
import 'dart:convert';

class ContactForm extends StatefulWidget {
  ContactForm({Key key, this.db, this.contact}) : super(key: key);

  final ContactsDatabase db;
  final Contact contact;

  @override
  _ContactFormState createState() => _ContactFormState(db, contact);
}

class _ContactFormState extends State<ContactForm> {
  _ContactFormState(this.database, this.contact);

  ContactsDatabase database;
  Contact contact;
  final _formKey = GlobalKey<FormState>();

  String newName;
  String newPhone;
  String newEmail;
  String newType;
  String newCountry;

  List<Country> countryList;

  @override
  void initState() {
    super.initState();
    setState(() {
      newName = contact.name;
      newPhone = contact.phone;
      newEmail = contact.email;
      newType = contact.type;
      newCountry = contact.country;
    });
    getCountries();
    print(countryList.length);
  }

  void getCountries() async {
    await api.fetchCountryList().then((response) => setState(() {
          var data = json.decode(response.body);
          Iterable list = data['countryList'] as List;
          countryList = list.map((model) => Country.fromJson(model)).toList();
        }));
  }

  void saveContact() async {
    if (_formKey.currentState.validate()) {
      print("Entries are valid");
      _formKey.currentState.save();

      Contact newContact = Contact(
        id: contact.id,
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
              initialValue: newName,
              decoration: InputDecoration(labelText: "Name"),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Name cannot be empty';
                } else if (isAlpha(value.replaceAll(RegExp(r"\s+"), ""))) {
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
              initialValue: newPhone,
              decoration: InputDecoration(labelText: "Phone"),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (isNumeric(trim(value)) || value.isEmpty) {
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
              initialValue: newEmail,
              decoration: InputDecoration(labelText: "Email"),
              validator: (value) {
                if (isEmail(trim(value)) || value.isEmpty) {
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
              items: <String>['Home', 'Personal', 'Work']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            // DropdownButton<String>(
            //   value: newCountry,
            //   icon: Icon(Icons.arrow_downward),
            //   iconSize: 24,
            //   elevation: 16,
            //   style: TextStyle(color: Colors.blue),
            //   onChanged: (String newValue) {
            //     setState(() {
            //       newCountry = newValue;
            //     });
            //   },
            //   items:
            //       countryList.map<DropdownMenuItem<String>>((Country country) {
            //     return DropdownMenuItem<String>(
            //       value: country.countryName,
            //       child: Text(country.countryName),
            //     );
            //   }).toList(),
            // ),
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
