import 'package:flutter/material.dart';
import 'package:foodsnap/db/user_database.dart';
import 'package:foodsnap/models/user.dart';
import 'package:foodsnap/screens/healthhub/healthhub.dart';
import 'package:foodsnap/screens/profile/account_settings_page.dart';
import 'package:foodsnap/screens/profile/avatar_edit_page.dart';
import 'package:foodsnap/screens/profile/change_email.dart';
import 'package:foodsnap/screens/profile/change_password.dart';
import 'package:foodsnap/screens/recipes/recipes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodsnap/screens/profile/edit_user_details.dart';
import 'package:foodsnap/screens/diary/diary.dart';
import 'dart:io';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  User? loggedInUser;
  int _currentIndex = 3;
  File? _userAvatar;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    if (loggedInUser != null && loggedInUser!.urlAvatar != null) {
      _userAvatar = File(loggedInUser!.urlAvatar!);
    }
  }

  Future<void> _fetchUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');

    if (storedUsername != null) {
      User? user = await UserDatabase.instance.getUserByUsername(storedUsername);
      if (user != null) {
        setState(() {
          loggedInUser = user;
          if (loggedInUser != null && loggedInUser!.urlAvatar != null) {
            _userAvatar = File(loggedInUser!.urlAvatar!);
          }
        });
      }
    }
  }


  void _onImageSelected(File? image) {
    if (image != null) {

      setState(() {
        _userAvatar = image;
      });
    }
  }

  void _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', '');

    //Navigator.pushReplacementNamed(context, '/login');
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "User Profile",
      //     style: TextStyle(
      //       color: Colors.black,
      //     ),
      //   ),
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         _logout();
      //       },
      //       icon: Icon(Icons.logout, color: Colors.red)
      //     )
      //   ],
      //   backgroundColor: Colors.transparent,
      //   automaticallyImplyLeading: false,
      //   elevation: 0.0,
      //   centerTitle: true,
      // ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFFF4747)
              ),
            ),
          ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFF4747)
                    ),
                    height: 60,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.chevron_left, color: Colors.white, size: 30,)
                        ),
                        Spacer(),
                        Text(
                          "User Profile",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "SegoeUIBold",
                            color: Colors.white,
                          )
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              _logout();
                            },
                            icon: Icon(Icons.logout, color: Colors.white)
                        )
                      ],
                    )
                  ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF4E00CB),
            ),
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 70), // Add space if needed
                if (loggedInUser != null) ...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Center the Column vertically
                    children: [
                      _userAvatar != null
                          ? CircleAvatar(
                        radius: 60,
                        backgroundImage: FileImage(_userAvatar!),
                      )
                          : CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage('assets/images/profilephoto.png'),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${loggedInUser!.username}',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontFamily: "SegoeUIBold",
                          fontSize: 20,
                        ),
                      ),
                    ],
                  )
                ],
                SizedBox(width: 20),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFFFFFFF),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileImagePage(
                            onImageSelected: _onImageSelected,
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Color(0xFF2A2A2A),
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // if (_userAvatar != null)
                      //   CircleAvatar(
                      //     radius: 50,
                      //     backgroundImage: FileImage(_userAvatar!),
                      //   ),
                    Text(
                      'Your Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "SegoeUIBold",
                        color: Color(0xFF707070),
                      ),
                    ),
                    SizedBox(height: 10),
                    if (loggedInUser != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                              color: Color(0xFFc4cfff),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            height: 125,
                            width: 165,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.group, color: Color(0xFF5c7aff)),
                                    SizedBox(width: 5,),
                                    Text(
                                      "Gender",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "MontserratBold",
                                        color: Color(0xFF5c7aff)
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${loggedInUser!.gender}',
                                      style: TextStyle(
                                        fontFamily: "MontserratBold",
                                        fontSize: 35,
                                        color: Color(0xFF5c7aff)
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                              color: Color(0xFFc1ffbd),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            height: 125,
                            width: 165,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.person, color: Color(0xFF0cc400)),
                                    SizedBox(width: 5,),
                                    Text(
                                      "Age",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: "MontserratBold",
                                          color: Color(0xFF0cc400)
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${loggedInUser!.age}',
                                      style: TextStyle(
                                          fontFamily: "MontserratBold",
                                          fontSize: 35,
                                          color: Color(0xFF0cc400)
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                              color: Color(0xFFff977a),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            height: 125,
                            width: 165,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.height, color: Color(0xFFd92f00)),
                                    SizedBox(width: 5,),
                                    Text(
                                      "Height",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: "MontserratBold",
                                          color: Color(0xFFd92f00)
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${loggedInUser!.height}',
                                      style: TextStyle(
                                          fontFamily: "MontserratBold",
                                          fontSize: 35,
                                          color: Color(0xFFd92f00)
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                                      child: Text(
                                        "cm",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontFamily: "MontserratBold",
                                          color: Color(0xFFd92f00)
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                              color: Color(0xFFffe28a),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            height: 125,
                            width: 165,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.monitor_weight, color: Color(0xFFebb000)),
                                    SizedBox(width: 5,),
                                    Text(
                                      "Gender",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: "MontserratBold",
                                          color: Color(0xFFebb000)
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${loggedInUser!.weight}',
                                      style: TextStyle(
                                          fontFamily: "MontserratBold",
                                          fontSize: 35,
                                          color: Color(0xFFebb000)
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                                      child: Text(
                                        "kg",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontFamily: "MontserratBold",
                                          color: Color(0xFFebb000)
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    TextButton(
                      onPressed: () async {
                        User? updatedUser = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditUserDetailsPage(user: loggedInUser!),
                          ),
                        );

                        if (updatedUser != null) {
                          setState(() {
                            loggedInUser = updatedUser;
                          });
                        }
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.edit,
                                size: 25,
                                color: Color(0xFF707070),
                              ),
                            ),
                            TextSpan(
                              text: ' Change Details',
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
                            builder: (context) => AccountSettingsPage(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.person,
                                size: 25,
                                color: Color(0xFF707070),
                              ),
                            ),
                            TextSpan(
                              text: ' Account Settings',
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
        ],
      ),
      // bottomNavigationBar: Container(
      //   height: 60,
      //   decoration: BoxDecoration(
      //     color: Color(0xFFf9f9f8),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.grey.withOpacity(0.3),
      //         spreadRadius: 2,
      //         blurRadius: 5,
      //         offset: Offset(0, 3),
      //       ),
      //     ],
      //   ),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: [
      //       IconButton(
      //         icon: Icon(
      //           Icons.home,
      //           color: _currentIndex == 0 ? Color(0xFF5c7aff) : Color(0xFF002766),
      //           size: 30,
      //         ),
      //         onPressed: () {
      //           setState(() {
      //             _currentIndex = 0;
      //           });
      //           //Navigator.pushReplacementNamed(context, "/diary");
      //           Navigator.pushReplacement(context, PageRouteBuilder(
      //             pageBuilder: (context, animation, secondaryAnimation) => DiaryPage(),
      //             transitionDuration: Duration(milliseconds: 0),
      //             transitionsBuilder:
      //                 (context, animation, secondaryAnimation, child) {
      //               return child;
      //             },
      //           ));
      //         },
      //       ),
      //       IconButton(
      //         icon: Icon(
      //           Icons.receipt_long,
      //           color: _currentIndex == 1 ? Color(0xFF5c7aff) : Color(0xFF002766),
      //           size: 30,
      //         ),
      //         onPressed: () {
      //           setState(() {
      //             _currentIndex = 1;
      //           });
      //           //Navigator.pushReplacementNamed(context, Routes.search);
      //           Navigator.pushReplacement(context, PageRouteBuilder(
      //             pageBuilder: (context, animation, secondaryAnimation) => RecipePage(),
      //             transitionDuration: Duration(milliseconds: 0),
      //             transitionsBuilder:
      //                 (context, animation, secondaryAnimation, child) {
      //               return child;
      //             },
      //           ));
      //         },
      //       ),
      //       IconButton(
      //         icon: Icon(
      //           Icons.health_and_safety,
      //           color: _currentIndex == 2 ? Color(0xFF5c7aff) : Color(0xFF002766),
      //           size: 30,
      //         ),
      //         onPressed: () {
      //           setState(() {
      //             _currentIndex = 2;
      //           });
      //           //Navigator.pushReplacementNamed(context, Routes.favorites);
      //           Navigator.pushReplacement(context, PageRouteBuilder(
      //             pageBuilder: (context, animation, secondaryAnimation) => HealthHubPage(),
      //             transitionDuration: Duration(milliseconds: 0),
      //             transitionsBuilder:
      //                 (context, animation, secondaryAnimation, child) {
      //               return child;
      //             },
      //           ));
      //         },
      //       ),
      //       IconButton(
      //         icon: Icon(
      //           Icons.person,
      //           color: _currentIndex == 3 ? Color(0xFF5c7aff) : Color(0xFF002766),
      //           size: 30,
      //         ),
      //         onPressed: () {
      //           setState(() {
      //             _currentIndex = 3;
      //           });
      //           //Navigator.pushNamed(context, Routes.addNote).then((_) => _refreshNotes());
      //           //Navigator.pushReplacementNamed(context, '/user_profile');
      //           Navigator.pushReplacement(context, PageRouteBuilder(
      //             pageBuilder: (context, animation, secondaryAnimation) => UserProfilePage(),
      //             transitionDuration: Duration(milliseconds: 0),
      //             transitionsBuilder:
      //                 (context, animation, secondaryAnimation, child) {
      //               return child;
      //             },
      //           ));
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
