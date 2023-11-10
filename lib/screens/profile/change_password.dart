import 'package:flutter/material.dart';
import 'package:foodsnap/db/user_database.dart';
import 'package:foodsnap/models/user.dart';
import 'package:foodsnap/screens/profile/account_settings_page.dart';
import 'package:foodsnap/screens/profile/user_profile.dart';

class ChangePasswordPage extends StatefulWidget {
  final User user;

  ChangePasswordPage({required this.user});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: currentPasswordController,
                obscureText: _isPasswordVisible ? false : true,
                decoration: InputDecoration(
                  hintText: 'Change Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Current password is required';
                  }
                  if (value != widget.user.password) {
                    return 'Current password is incorrect';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: newPasswordController,
                obscureText: _isPasswordVisible ? false : true,
                decoration: InputDecoration(
                  hintText: 'New password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'New password is required';
                  }
                  if (currentPasswordController.text == value) {
                    return 'New password should not match with old password';
                  }
                  if(currentPasswordController.text.length > 8) {
                    return 'New password should be longer than 8 characters';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: confirmNewPasswordController,
                obscureText: _isPasswordVisible ? false : true,
                decoration: InputDecoration(hintText: 'Confirm New Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm new password is required';
                  }
                  if (value != newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  if (currentPasswordController.text == value) {
                    return 'New password should not match with old password';
                  }
                  if(currentPasswordController.text.length > 8) {
                    return 'New password should be longer than 8 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      await _changePassword();
                    }
                  },
                  child: Text(
                    "Change Password",
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

  Future<void> _changePassword() async {
    final String newPass = newPasswordController.text;

    User updatedUser = widget.user.copy(password: newPass);
    await UserDatabase.instance.updateUser(updatedUser);

    Navigator.pop(context, updatedUser);
  }
}
