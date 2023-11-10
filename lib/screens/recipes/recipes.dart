import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:foodsnap/screens/diary/diary.dart';
import 'package:foodsnap/screens/healthhub/healthhub.dart';
import 'package:foodsnap/screens/locator/locator.dart';
import 'package:foodsnap/screens/profile/user_profile.dart';
import 'package:foodsnap/screens/recipes/recipe_details.dart';
import 'package:foodsnap/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class RecipePage extends StatefulWidget {
  const RecipePage({Key? key}) : super(key: key);

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  int _currentIndex = 1;
  List<Map<String, dynamic>> recipes = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchRecipes('');
  }

  Future<void> fetchRecipes(String query) async {
    final apiKey = 'f53d966dcb9643ec823e25238722ec4e';
    final response = await http.get(
      Uri.parse(
        'https://api.spoonacular.com/recipes/search?query=$query&apiKey=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> results =
      List<Map<String, dynamic>>.from(data['results']);
      setState(() {
        recipes = results;
      });
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Recipes',
            style: TextStyle(
                color: Colors.white,
                fontFamily: "SegoeUIBold"
            ),
          ),
          leading: IconButton(
              onPressed: () {
                showModalBottomSheet(context: context, builder: (context) => Services());
              },
              icon: Icon(Icons.sort, size: 35, color: Color(0xFFFFFFFF))
          ),
          actions: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(context: context, builder: (context) => UserProfilePage(), isScrollControlled: true);
              },
              child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[100],
                  child: Icon(Icons.person, size: 20, color: Color(0xFF707070))
              ),
            ),
            SizedBox(width: 10,)
          ],
          centerTitle: true,
          //backgroundColor: Color(0xFFF8F8F9),
          //backgroundColor: Color(0xFFf7f7f7),
          backgroundColor: Color(0xFFFF9827),
          elevation: 0.0,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3,
                      spreadRadius: 3,
                      offset: Offset(0, 0),
                      color: Colors.grey.withOpacity(0.15),
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  style: TextStyle(
                    fontFamily: "SegoeUIBold"
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    hintText: 'Search for a recipe...',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    suffixIcon: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadiusDirectional.horizontal(
                          end: Radius.circular(10)
                        )
                      ),
                      child: IconButton(
                        icon: Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          fetchRecipes(searchController.text);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  String baseUrl = 'https://spoonacular.com/recipeImages/';
                  return GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => RecipeDetailPage(
                      //       recipeId: recipe['id'],
                      //       readyInMinutes: recipe['readyInMinutes'],
                      //     ),
                      //   ),
                      // );
                      showModalBottomSheet(context: context, builder: (context) => RecipeDetailPage(
                        recipeId: recipe['id'],
                        readyInMinutes: recipe['readyInMinutes'],
                        servingSize: recipe['servings'],
                      ), isScrollControlled: true
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius:
                            BorderRadius.circular(15),
                            child: SizedBox(
                              height:
                              90,
                              width:
                              120,
                              child: Image.network('$baseUrl${recipe['image'].toString()}', fit: BoxFit.cover,)
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              //leading: Image.network('$baseUrl${recipe['image'].toString()}'),
                              title: Text(recipe['title'].toString(), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: "SegoeUIBold")),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 10), // Add padding for some space around the text
                                      height: 30,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.group, size: 18, color: Color(0xFF707070)),
                                          SizedBox(width: 3),
                                          Text(
                                            '${recipe['servings']}',
                                            style: TextStyle(
                                              fontFamily: "SegoeUIBold",
                                              color: Color(0xFF707070),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Icon(Icons.schedule, size: 18, color: Color(0xFF707070)),
                                          SizedBox(width: 3),
                                          Text(
                                            '${recipe['readyInMinutes']} min',
                                            style: TextStyle(
                                              fontFamily: "SegoeUIBold",
                                              color: Color(0xFF707070),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              //subtitle: Text('Prep Time: ${recipe['readyInMinutes']} minutes'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Color(0xFFf9f9f8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: _currentIndex == 0 ? Color(0xFF5c7aff) : Color(0xFF002766),
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                  //Navigator.pushReplacementNamed(context, "/diary");
                  Navigator.pushReplacement(context, PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => DiaryPage(),
                    transitionDuration: Duration(milliseconds: 0),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return child;
                    },
                  ));
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.receipt_long,
                  color: _currentIndex == 1 ? Color(0xFF5c7aff) : Color(0xFF002766),
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                  //Navigator.pushReplacementNamed(context, Routes.search);
                  Navigator.pushReplacement(context, PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => RecipePage(),
                    transitionDuration: Duration(milliseconds: 0),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return child;
                    },
                  ));
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.health_and_safety,
                  color: _currentIndex == 2 ? Color(0xFF5c7aff) : Color(0xFF002766),
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                  //Navigator.pushReplacementNamed(context, Routes.favorites);
                  Navigator.pushReplacement(context, PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => HealthHubPage(),
                    transitionDuration: Duration(milliseconds: 0),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return child;
                    },
                  ));
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.map,
                  color: _currentIndex == 3 ? Color(0xFF5c7aff) : Color(0xFF002766),
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                  //Navigator.pushNamed(context, Routes.addNote).then((_) => _refreshNotes());
                  //Navigator.pushReplacementNamed(context, '/user_profile');
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            LocatorPage(),
                        transitionDuration: Duration(milliseconds: 0),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return child;
                        },
                      ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// class RecipeListPage extends StatefulWidget {
//   @override
//   _RecipeListPageState createState() => _RecipeListPageState();
// }
//
// class _RecipeListPageState extends State<RecipeListPage> {
//   List<Map<String, dynamic>> recipes = [];
//   TextEditingController searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     fetchRecipes('');
//   }
//
//   Future<void> fetchRecipes(String query) async {
//     final apiKey = 'f53d966dcb9643ec823e25238722ec4e';
//     final response = await http.get(
//       Uri.parse(
//         'https://api.spoonacular.com/recipes/search?query=$query&apiKey=$apiKey',
//       ),
//     );
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       final List<Map<String, dynamic>> results =
//       List<Map<String, dynamic>>.from(data['results']);
//       setState(() {
//         recipes = results;
//       });
//     } else {
//       throw Exception('Failed to load recipes');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Recipes'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               controller: searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search for a recipe...',
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.search),
//                   onPressed: () {
//                     fetchRecipes(searchController.text);
//                   },
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: recipes.length,
//               itemBuilder: (context, index) {
//                 final recipe = recipes[index];
//                 String baseUrl = 'https://spoonacular.com/recipeImages/';
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => RecipeDetailPage(
//                           recipeId: recipe['id'],
//                           readyInMinutes: recipe['readyInMinutes'],
//                         ),
//                       ),
//                     );
//                   },
//                   child: ListTile(
//                     leading: Image.network('$baseUrl${recipe['image'].toString()}'),
//                     title: Text(recipe['title'].toString()),
//                     subtitle: Text('Prep Time: ${recipe['readyInMinutes']} minutes'),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }