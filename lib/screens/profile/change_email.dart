import 'package:flutter/material.dart';
import 'package:foodsnap/db/user_database.dart';
import 'package:foodsnap/models/user.dart';
import 'package:foodsnap/screens/profile/account_settings_page.dart';
import 'package:foodsnap/screens/profile/user_profile.dart';

class ChangeEmailPage extends StatefulWidget {
  final User user;

  ChangeEmailPage({required this.user});

  @override
  _ChangeEmailPageState createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController currentEmailController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Email",
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
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: currentEmailController,
                decoration: InputDecoration(labelText: 'Current Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Current email is required';
                  }
                  if (value != widget.user.email) {
                    return 'Current email is incorrect';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: newEmailController,
                decoration: InputDecoration(labelText: 'New Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'New email is required';
                  }
                  if (currentEmailController.text == value) {
                    return 'New email should not match with old password';
                  }
                  if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
                    return 'Email must be in valid format';
                  }
                  // You can add more validation rules for the new password
                  return null;
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: 180,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      await _changeEmail();
                    }
                  },
                  child: Text(
                    "Change Email",
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

  Future<void> _changeEmail() async {
    final String newEmail = newEmailController.text;

    // Update the user's email in the database
    User updatedUser = widget.user.copy(email: newEmail);
    await UserDatabase.instance.updateUser(updatedUser);

    Navigator.pop(context, updatedUser);
  }
}
