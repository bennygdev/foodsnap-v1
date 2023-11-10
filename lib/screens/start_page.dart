import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text('Start page'),
        // ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                    "assets/images/Foodsnap.png",
                  height: 160,
                  width: 160,
                ),
                SizedBox(height: 60),
                Text(
                  "Foodsnap",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: "MontserratBold"
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Get started with Foodsnap and join others for a healthy lifestyle today",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF707070),
                    fontFamily: "SegoeUI"
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 55,
                  width: 400,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFF7F7F7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      //backgroundColor: Color(0xFF399CFF),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 55,
                  width: 400,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/register");
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 20,
                        //color: Color(0xFF399CFF),
                        color: Color(0xFF7E7E7E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      //backgroundColor: Color(0xFFF1F1F1),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17.0),
                        //side: BorderSide(color: Color(0xFF399CFF), width: 2.0),
                        side: BorderSide(color: Color(0xFFC4C4C4), width: 2.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
