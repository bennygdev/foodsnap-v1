import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodsnap/screens/diary/diary.dart';
import 'package:foodsnap/screens/healthhub/healthhub.dart';
import 'package:foodsnap/screens/profile/user_profile.dart';
import 'package:foodsnap/screens/recipes/recipes.dart';
import 'package:foodsnap/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocatorPage extends StatefulWidget {
  const LocatorPage({Key? key}) : super(key: key);

  @override
  State<LocatorPage> createState() => _LocatorPageState();
}

class _LocatorPageState extends State<LocatorPage> {
  int _currentIndex = 3;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool _searchIcon = false;
  LocationData? _currentLocation;
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? localLatLng;

  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  late LatLng currentLocation;
  bool _isLocationAvailable = false;

  void getCurrentLocation() async {
    Location location = Location();

    try {
      final LocationData locationData = await location.getLocation();
      setState(() {
        _currentLocation = locationData;
        double? localLat = _currentLocation?.latitude;
        double? localLong = _currentLocation?.longitude;
        print('current location: $_currentLocation');
        print("Latitude: $localLat");
        print("Longitude: $localLong");
        localLatLng = LatLng(localLat ?? 0.0, localLong ?? 0.0);

        // Initialize currentLocation within this method
        currentLocation = localLatLng!;
        _isLocationAvailable = true; // Set location availability
      });
    } catch (e) {
      print("Error getting location: $e");
      // Handle location error here
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  void _searchLocation(String query) async {
    final apiUrl = 'https://www.onemap.gov.sg/api/common/elastic/search?searchVal=$query&returnGeom=Y&getAddrDetails=Y';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;

      setState(() {
        searchResults = results.cast<Map<String, dynamic>>();
      });
    } else {
      // Handle errors, e.g., display an error message to the user.
      print("Error: ${response.statusCode}");
    }
  }

  // void _printCoordinates(String latitude, String longitude) {
  //   print("Latitude: $latitude");
  //   print("Longitude: $longitude");
  // }
  Set<Marker> markers = {

  };

  void _printCoordinates(String latitude, String longitude) {
    print("Latitude: $latitude");
    print("Longitude: $longitude");

    // Update the selected location's coordinates
    double lat = double.parse(latitude);
    double lng = double.parse(longitude);
    setState(() {
      localLatLng = LatLng(lat, lng);
      searchResults.clear();
    });

    // Update the Google Maps camera position
    _goToSelectedLocation();
  }

  void _goToSelectedLocation() async {
    final GoogleMapController controller = await _controller.future;
    if (localLatLng != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: localLatLng!,
          zoom: 17,
        ),
      ));

      // Clear previous markers and add a new marker for the selected location
      Set<Marker> newMarkers = {};
      newMarkers.add(Marker(
        markerId: MarkerId("selectedLocation"),
        position: localLatLng!,
      ));

      setState(() {
        _isLocationAvailable = true;
        // Update the markers on the map
        markers = newMarkers;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Locator',
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
        backgroundColor: Color(0xFFB636FF),
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          _isLocationAvailable ? Container(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            height: 650,
            width: double.infinity,
            child: Center(
              // child: GoogleMap(
              //   initialCameraPosition: CameraPosition(
              //     target: currentLocation,
              //     zoom: 17
              //   ),
              //   markers: {
              //     Marker(
              //       markerId: MarkerId("source"),
              //       position: currentLocation
              //     ),
              //   },
              // ),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: currentLocation,
                  zoom: 17,
                ),
                //markers: markers,
                markers: Set.from([
                  Marker(
                    markerId: MarkerId("source"),
                    position: currentLocation,
                  ),
                  if (localLatLng != null)
                    Marker(
                      markerId: MarkerId("selectedLocation"),
                      position: localLatLng!,
                    ),
                ]),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),

            ),
          ) : Center(child: CircularProgressIndicator()),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                    controller: _searchController,
                    style: TextStyle(
                      fontFamily: "SegoeUIBold",
                    ),
                    onChanged: (query) {
                      _searchIcon = true;
                      if (query.isEmpty) {
                        setState(() {
                          // Clear search results when the search bar is empty.
                          searchResults.clear();
                          _searchIcon = false;
                        });
                      } else {
                        _searchLocation(query);
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      hintText: "Search Location...",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      suffixIcon: Container(
                        decoration: BoxDecoration(
                          color: _searchIcon ? Colors.red : Colors.blue,
                          borderRadius: BorderRadiusDirectional.horizontal(
                            end: Radius.circular(10),
                          ),
                        ),
                        child: IconButton(
                          icon: _searchIcon ? Icon(Icons.clear, color: Colors.white) : Icon(Icons.search, color: Colors.white),
                          onPressed: () {
                            // Clear the search bar and search results.
                            _searchController.clear();
                            setState(() {
                              searchResults.clear();
                              _searchIcon = false;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    width: 355,
                    height: 220,
                  ),
                  if (searchResults.isNotEmpty)
                    Positioned(
                      top: 5, // Adjust the position as needed
                      left: 0,
                      right: 0,
                      bottom: 0,
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
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final result = searchResults[index];
                            final name = result['SEARCHVAL'] ?? '';
                            final latitude = result['LATITUDE'] ?? '';
                            final longitude = result['LONGITUDE'] ?? '';

                            return GestureDetector(
                              onTap: () {
                                _printCoordinates(latitude, longitude);
                              },
                              child: ListTile(
                                title: Text(name, style: TextStyle(fontFamily: "SegoeUIBold")),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ],
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
    );
  }
}
