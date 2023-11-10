// import 'package:flutter/material.dart';
//
// class RecipeDetailPage extends StatelessWidget {
//   final Map<String, dynamic> recipe;
//
//   RecipeDetailPage({required this.recipe});
//
//   @override
//   Widget build(BuildContext context) {
//     String baseUrl = 'https://spoonacular.com/recipeImages/';
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(recipe['title'].toString()),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.network('$baseUrl${recipe['image'].toString()}'),
//             SizedBox(height: 16.0),
//             Text('Prep Time: ${recipe['readyInMinutes']} minutes'),
//             SizedBox(height: 16.0),
//             Text('Ingredients:', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
//             SizedBox(height: 8.0),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: _buildIngredientsList(recipe['extendedIngredients']),
//             ),
//             SizedBox(height: 16.0),
//             Text('Instructions:', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
//             SizedBox(height: 8.0),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: _buildInstructionsList(recipe['analyzedInstructions']),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   List<Widget> _buildIngredientsList(dynamic ingredients) {
//     if (ingredients is List) {
//       return ingredients.map<Widget>((ingredient) {
//         return Text('- ${ingredient['originalString']}');
//       }).toList();
//     } else {
//       return [Text('No ingredients available.')];
//     }
//   }
//
//   List<Widget> _buildInstructionsList(dynamic instructions) {
//     if (instructions is List && instructions.isNotEmpty) {
//       return instructions[0]['steps'].map<Widget>((step) {
//         return Text('${step['number']}. ${step['step']}');
//       }).toList();
//     } else {
//       return [Text('No instructions available.')];
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecipeDetailPage extends StatefulWidget {
  final int recipeId;
  final int readyInMinutes;
  final int servingSize;

  RecipeDetailPage({required this.recipeId, required this.readyInMinutes, required this.servingSize});

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  Map<String, dynamic> recipe = {};

  @override
  void initState() {
    super.initState();
    fetchRecipeDetail();
  }

  Future<void> fetchRecipeDetail() async {
    final apiKey = 'f53d966dcb9643ec823e25238722ec4e';
    final response = await http.get(
      Uri.parse(
        'https://api.spoonacular.com/recipes/${widget.recipeId}/information?apiKey=$apiKey&includeNutrition=false',
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        recipe = data;
      });
    } else {
      throw Exception('Failed to load recipe details');
    }
  }

  @override
  Widget build(BuildContext context) {
    String baseUrl = 'https://spoonacular.com/recipeImages/';

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(), backgroundColor: Colors.white),
              child: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Color(0xFF005E75),
              ),
            ),
            SizedBox(height: 10),
            FutureBuilder(
              // Simulate loading delay if needed
              future: Future.delayed(Duration(seconds: 1), () => recipe),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While waiting for data, show loading indicator
                  return Container(height: 700, child: Center(child: CircularProgressIndicator()));
                } else if (snapshot.hasError) {
                  // Handle error if necessary
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  // Handle case where data is null
                  return Center(child: Text('Data not available'));
                }

                final loadedRecipe = snapshot.data as Map<String, dynamic>;

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recipe['title'].toString(), style: TextStyle(fontFamily: "SegoeUIBold", fontSize: 25, color: Color(0xFF424242))),
                      SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          height: 180,
                          width: double.infinity,
                          child: Image.network(
                            loadedRecipe['image'] != null && loadedRecipe['image'].toString().isNotEmpty
                                ? '${loadedRecipe['image'].toString()}'
                                : 'https://images.unsplash.com/photo-1560780552-ba54683cb263', // Provide a URL to a fallback image
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFa6e9d6),
                              borderRadius: BorderRadius.circular(30)
                            ),
                            height: 55,
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.play_arrow, color: Color(0xFF2cc98c), size: 35,),
                                SizedBox(width: 2,),
                                Text(
                                  "Start",
                                  style: TextStyle(
                                    color: Color(0xFF2cc98c),
                                    fontFamily: "SegoeUIBold",
                                    fontSize: 20
                                  )
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () {

                              },
                              style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  backgroundColor: Color(0xFFcaceee),),
                              child: Icon(
                                Icons.download,
                                color: Color(0xFF6570dd),
                                size: 35,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFFFFFFF),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 3,
                                  spreadRadius: 3,
                                  offset: Offset(0, 0),
                                  color: Colors.grey.withOpacity(0.15),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(25),
                            ),
                            height: 60,
                            width: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.group, color: Color(0xFF707070), size: 25,),
                                SizedBox(width: 10,),
                                Text(
                                    '${loadedRecipe['servings']}',
                                    style: TextStyle(
                                        color: Color(0xFF424242),
                                        fontFamily: "SegoeUIBold",
                                        fontSize: 20
                                    )
                                )
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFFFFFFF),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 3,
                                  spreadRadius: 3,
                                  offset: Offset(0, 0),
                                  color: Colors.grey.withOpacity(0.15),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(25),
                            ),
                            height: 60,
                            width: 205,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.schedule, color: Color(0xFF707070), size: 25,),
                                SizedBox(width: 10,),
                                Text(
                                    'Prep ${loadedRecipe['readyInMinutes']} min',
                                    style: TextStyle(
                                        color: Color(0xFF424242),
                                        fontFamily: "SegoeUIBold",
                                        fontSize: 16
                                    )
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Text('Ingredients', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xFF424242))),
                      SizedBox(height: 8.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3,
                              spreadRadius: 3,
                              offset: Offset(0, 0),
                              color: Colors.grey.withOpacity(0.15),
                            ),
                          ],
                        ),
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _buildIngredientsList(loadedRecipe['extendedIngredients']),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text('Instructions', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xFF424242))),
                      SizedBox(height: 8.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3,
                              spreadRadius: 3,
                              offset: Offset(0, 0),
                              color: Colors.grey.withOpacity(0.15),
                            ),
                          ],
                        ),
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _buildInstructionsList(loadedRecipe['analyzedInstructions']),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildIngredientsList(dynamic ingredients) {
    if (ingredients is List) {
      return ingredients.map<Widget>((ingredient) {
        return Text('- ${ingredient['original']}', style: TextStyle(fontSize: 15));
      }).toList();
    } else {
      return [Text('No ingredients available.')];
    }
  }

  List<Widget> _buildInstructionsList(dynamic instructions) {
    List<Widget> instructionWidgets = [];

    if (instructions is List && instructions.isNotEmpty) {
      final steps = instructions[0]['steps'];
      if (steps is List && steps.isNotEmpty) {
        for (var step in steps) {
          final instructionNumber = step['number'];
          final instructionText = step['step'];

          final instructionWidget = Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 13,
                  child: Text("$instructionNumber", style: TextStyle(color: Color(0xFFFFFFFF))),
                  backgroundColor: Color(0xFF419DFF),
                ),
                SizedBox(width: 5),
                Expanded(child: Text("$instructionText", style: TextStyle(fontSize: 15)))
              ],
            ),
          );

          instructionWidgets.add(instructionWidget);
        }
      }
    } else {
      // Add a message for no instructions available
      instructionWidgets.add(Text('No instructions available.'));
    }

    return instructionWidgets;
  }

}
