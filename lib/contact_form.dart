import "package:flutter/material.dart";
import "package:validators/validators.dart";

class ContactForm extends StatefulWidget {
  ContactForm({Key key}) : super(key: key);

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = "--";

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
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Email"),
              validator: (value) {
                if (isEmail(value)) {
                  return null;
                }
                return "Incorrect format";
              },
            ),
            DropdownButton<String>(
              value: dropdownValue,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.blue),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
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
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  print("Entries are valid");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
