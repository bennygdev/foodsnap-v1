import 'package:flutter/material.dart';
import 'package:foodsnap/models/user.dart';
import 'package:foodsnap/db/diary_database.dart';
import 'package:foodsnap/screens/profile_gathering/age_input_page.dart';
import 'package:foodsnap/screens/diary/add_diary_page.dart';
import 'package:foodsnap/screens/diary/diary.dart';
import 'package:foodsnap/screens/diary/edit_diary_page.dart';
import 'package:foodsnap/screens/profile_gathering/gender_input_page.dart';
import 'package:foodsnap/screens/profile_gathering/height_input_page.dart';
import 'package:foodsnap/screens/auth/login_page.dart';
import 'package:foodsnap/screens/auth/register_page.dart';
import 'package:foodsnap/screens/start_page.dart';
import 'package:foodsnap/screens/profile/user_profile.dart';
import 'package:foodsnap/screens/profile_gathering/weight_input_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Diary());
}

class Diary extends StatelessWidget {
  const Diary({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
      routes:{
        // default slash for default splash screen
        "/": (context) => StartPage(),
        "/login": (context) => LoginPage(),
        "/register": (context) => RegisterPage(),
        "/diary":(context) => DiaryPage(),
        "/adddiary": (context) => AddDiaryPage(),
        "/age_input_form": (context) {
          final user = ModalRoute.of(context)?.settings.arguments as User;
          return AgeInputFormPage(user: user);
        },
        "/gender_input_form": (context) {
          final user = ModalRoute.of(context)?.settings.arguments as User;
          return GenderInputFormPage(user: user);
        },
        "/weight_input_form": (context) {
          final user = ModalRoute.of(context)?.settings.arguments as User;
          return WeightInputFormPage(user: user);
        },
        "/height_input_form": (context) {
          final user = ModalRoute.of(context)?.settings.arguments as User;
          return HeightInputFormPage(user: user);
        },
        "/user_profile": (context) => UserProfilePage(),
      },
    );
  }
}