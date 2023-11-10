import 'package:flutter/material.dart';
import 'package:foodsnap/db/user_database.dart';
import 'package:foodsnap/models/user.dart';

class EditUserDetailsPage extends StatefulWidget {
  final User user;

  EditUserDetailsPage({required this.user});

  @override
  _EditUserDetailsPageState createState() => _EditUserDetailsPageState();
}

class _EditUserDetailsPageState extends State<EditUserDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  String? _newGender;
  String? _newAge;
  String? _newWeight;
  String? _newHeight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit User Details',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _newGender ?? widget.user.gender,
                onChanged: (String? newValue) {
                  setState(() {
                    _newGender = newValue;
                  });
                },
                items: ['Male', 'Female']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Gender'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Gender is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: widget.user.age.toString(), // Convert int to String
                decoration: InputDecoration(labelText: 'Age'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Age is required';
                  }
                  return null;
                },
                onSaved: (value) => _newAge = value,
              ),
              TextFormField(
                initialValue: widget.user.height.toString(), // Convert int to String
                decoration: InputDecoration(labelText: 'Height'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Height is required';
                  }
                  return null;
                },
                onSaved: (value) => _newHeight = value,
              ),
              TextFormField(
                initialValue: widget.user.weight.toString(), // Convert int to String
                decoration: InputDecoration(labelText: 'Weight'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Weight is required';
                  }
                  return null;
                },
                onSaved: (value) => _newWeight = value,
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: 180,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      User updatedUser = widget.user.copy(
                        gender: _newGender ?? widget.user.gender,
                        age: int.tryParse(_newAge ?? '') ?? widget.user.age,
                        weight: int.tryParse(_newWeight ?? '') ?? widget.user.weight,
                        height: int.tryParse(_newHeight ?? '') ?? widget.user.height,
                      );

                      await UserDatabase.instance.updateUser(updatedUser);

                      Navigator.pop(context, updatedUser); // Go back to user profile page
                    }
                  },
                  child: Text(
                    "Save Changes",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    //backgroundColor: Color(0xFFF1F1F1),
                    backgroundColor: Color(0xFF006491),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
