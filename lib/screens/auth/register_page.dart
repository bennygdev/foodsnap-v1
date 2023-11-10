import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:foodsnap/models/user.dart';
import 'package:foodsnap/db/user_database.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();


  RegisterPage({Key? key}) : super(key: key);
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  String usernameError = '';
  String emailError = '';
  String passwordError = '';
  bool _isPasswordVisible = false;

  void _register(BuildContext context) async {
    setState(() {
      usernameError = '';
      emailError = '';
      passwordError = '';
    });

    final String username = usernameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;

    if (username.isEmpty) {
      setState(() => usernameError = 'Username is required');
      return;
    }

    if (email.isEmpty) {
      setState(() => emailError = 'Email is required');
      return;
    }

    if (password.isEmpty) {
      setState(() => passwordError = 'Password is required');
      return;
    }

    if (password.length < 8) {
      setState(() => passwordError = 'Password must be 8 characters or more');
      return;
    }

    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(email)) {
      setState(() => emailError = 'Email not in valid format');
      return;
    }

    final User? existingUser = await UserDatabase.instance.checkDuplicateUser(username, email);
    if (existingUser != null) {
      setState(() => errorMessage = 'Username or email already exists');
      return;
    }

    final User user = User(
      username: username,
      email: email,
      password: password,
    );

    final User? registeredUser = await UserDatabase.instance.registerUser(user);

    if (registeredUser != null) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      setState(() => errorMessage = 'Registration failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
                      "Register",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: "SegoeUIBold"
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Enter your credientials to register",
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
                'Username',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'SegoeUIBold',
                  color: Color(0xFF707070),
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: usernameController,
                style: TextStyle(
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  // labelText: "Email",
                  errorText: usernameError,
                  hintText: 'Enter your username',
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
                  hintText: 'Enter email',
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
                  hintText: 'Enter password',
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
              if (errorMessage.isNotEmpty)
                Text(errorMessage, style: TextStyle(color: Colors.red)),
              SizedBox(height: 20),
              Container(
                width: 400,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => _register(context),
                  child: Text(
                    'Register',
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
                        text: "Already have an account? ",
                        style: TextStyle(
                          color: Color(0xFF707070),
                          fontFamily: "SegoeUIBold",
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: 'Log in here',
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                          fontFamily: "SegoeUIBold",
                          fontSize: 14,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => {Navigator.pushReplacementNamed(context, '/login')},
                      ),
                    ],
                  ),
                ),
              ),
              //ElevatedButton(onPressed: () => _register(context), child: Text('Register')),
            ],
          ),
        ),
      ),
    );
  }
}