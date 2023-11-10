import 'package:flutter/material.dart';
import 'package:foodsnap/models/user.dart';
import 'package:foodsnap/db/user_database.dart';
import 'package:foodsnap/screens/healthhub/bmi_input_page.dart';
import 'package:foodsnap/screens/profile/change_email.dart';
import 'package:foodsnap/screens/profile/change_password.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AccountSettingsPage extends StatefulWidget {

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  User? loggedInUser;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails(); // Fetch user details when the page is initialized
  }

  Future<void> _fetchUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');

    if (storedUsername != null) {
      User? user = await UserDatabase.instance.getUserByUsername(storedUsername);
      setState(() {
        loggedInUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text("Account Information", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "This is your personal information, even if the account is for something such as a business or pet. It won't be part of your public profile. \n\nTo keep your account secure, don't enter an email address or phone number that belongs to someone else.",
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: "SegoeUI",
                ),
              ),
              SizedBox(height: 30),
              if (loggedInUser != null) ...[
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                        Icons.person
                    ),
                    SizedBox(width: 50),
                    Text(
                      '${loggedInUser!.username}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.email
                    ),
                    SizedBox(width: 50),
                    Text(
                      '${loggedInUser!.email}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                        Icons.key
                    ),
                    SizedBox(width: 50),
                    Text(
                      '${loggedInUser!.password}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),

              ] else ...[
                Text('Loading user details...'),
              ],
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeEmailPage(user: loggedInUser!)
                    ),
                  ).then((_) => _fetchUserDetails());;
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.email,
                          size: 25,
                          color: Color(0xFF707070),
                        ),
                      ),
                      TextSpan(
                        text: ' Change email',
                        style: TextStyle(
                          color: Color(0xFF707070),
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePasswordPage(user: loggedInUser!),
                    ),
                  ).then((_) => _fetchUserDetails());
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.key,
                          size: 25,
                          color: Color(0xFF707070),
                        ),
                      ),
                      TextSpan(
                        text: ' Change password',
                        style: TextStyle(
                          color: Color(0xFF707070),
                          fontSize: 17,
                        ),
                      ),
                    ],
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