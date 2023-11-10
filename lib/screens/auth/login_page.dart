import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:foodsnap/db/user_database.dart';
import 'package:foodsnap/models/user.dart';
import 'package:foodsnap/screens/profile_gathering/age_input_page.dart';
import 'package:foodsnap/screens/diary/diary.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();

  const LoginPage({Key? key}) : super(key: key);
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  String emailError = '';
  String passwordError = '';
  bool _isPasswordVisible = false;

  void _login(BuildContext context) async {
    setState(() {
      emailError = '';
      passwordError = '';
    });

    final String email = emailController.text;
    final String password = passwordController.text;

    if (email.isEmpty) {
      setState(() => emailError = 'Email is required');
      return;
    }

    if (password.isEmpty) {
      setState(() => passwordError = 'Password is required');
      return;
    }

    final User? user = await UserDatabase.instance.loginUser(email, password);

    if (user != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', user.username); // Store the username

      if (user.age == null || user.gender == null || user.weight == null || user.height == null) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => AgeInputFormPage(user: user),
            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        );
      } else {

        Navigator.pushReplacementNamed(context, '/diary');
      }
      //Navigator.pushReplacementNamed(context, '/diary');
    } else {
      setState(() => errorMessage = 'Invalid email or password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(
        //   "Login",
        //   style: TextStyle(
        //     color: Colors.black,
        //   ),
        // )
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/Foodsnap.png",
                  height: 120,
                  width: 120,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Text(
                      "Welcome back!",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: "SegoeUIBold"
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Enter your credientials to log in",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: "SegoeUIBold",
                        color: Color(0xFF707070),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Email',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'SegoeUIBold',
                  color: Color(0xFF707070),
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: emailController,
                style: TextStyle(
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  // labelText: "Email",
                  errorText: emailError,
                  hintText: 'Email address',
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFC4C4C4)),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFC4C4C4)),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
              ),
              Text(
                'Password',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'SegoeUIBold',
                  color: Color(0xFF707070),
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: passwordController,
                style: TextStyle(
                  fontSize: 15,
                ),
                obscureText: _isPasswordVisible ? false : true,
                decoration: InputDecoration(
                  // labelText: "Email",
                  errorText: passwordError,
                  hintText: 'Enter your password',
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFC4C4C4)),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFC4C4C4)),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
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
                  filled: true,
                  fillColor: Colors.transparent,
                ),
              ),
              if (errorMessage.isNotEmpty) Text(errorMessage, style: TextStyle(color: Colors.red)),
              // ElevatedButton(onPressed: () => _login(context), child: Text('Login')),
              SizedBox(height: 20),
              Container(
                width: 400,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => _login(context),
                  child: Text(
                    'Log in',
                    style: TextStyle(
                      fontFamily: "SegoeUIBold",
                      fontSize: 17,
                      color: Color(0xFFFFFFFF)
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    //backgroundColor: Color(0xFF3743FF),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          color: Color(0xFF707070),
                          fontFamily: "SegoeUIBold",
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: 'Register here',
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                          fontFamily: "SegoeUIBold",
                          fontSize: 14,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => {Navigator.pushReplacementNamed(context, "/register")},
                      )
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
