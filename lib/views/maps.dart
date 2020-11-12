import 'dart:async';
import 'dart:math' show cos, sqrt, asin;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:wakulima/requests/google_maps_requests.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  static double latitudeCurrent = 5.6037;
  static double longitudeCurrent = 0.1870;
  String _placeDistance;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  List coord = [
    [0.3031, 36.0800],
    [0.0074, 37.0722]
  ];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getCurrentLocation();
      coord.forEach((e) {
        print('lat ${e[0]}');
        _addMarker(LatLng(e[0], e[1]), e.toString());
      });
    });

    super.initState();
    // getVets();
    // print(getVets());
  }

  // Intial Map postion
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(latitudeCurrent, longitudeCurrent),
    zoom: -200,
  );

  void _getCurrentLocation() async {
    var location = Location();
    location.changeSettings(
      accuracy: LocationAccuracy.HIGH,
      distanceFilter: 0,
      interval: 50,
    );
    LocationData loc = await location.getLocation();
    latitudeCurrent = loc.latitude;
    longitudeCurrent = loc.longitude;
    _goToYourLocation();
    _addMarker(LatLng(latitudeCurrent, longitudeCurrent), "my location");

    List<geo.Placemark> addresses =
        await geo.Geolocator().placemarkFromCoordinates(
      latitudeCurrent,
      longitudeCurrent,
    );
    locationController.text = addresses[0].locality;
  }

  //Animating to the new user lat and long
  Future<void> _goToYourLocation() async {
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(latitudeCurrent, longitudeCurrent),
      zoom: 9.5,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                title: Text('Choose'),
              ),
              ListTile(
                title: Text('Veterinary Contacts'),
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => Authenticate()));
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              _controller.complete(controller);
            },
            mapType: MapType.normal,
            compassEnabled: true,
            markers: _markers,
            polylines: _polyLines,
          ),
          Positioned(
            top: 50.0,
            right: 15.0,
            left: 15.0,
            child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(1.0, 5.0),
                      blurRadius: 10,
                      spreadRadius: 3)
                ],
              ),
              child: TextField(
                cursorColor: Colors.black,
                controller: locationController,
                decoration: InputDecoration(
                  icon: Container(
                    margin: EdgeInsets.only(left: 20, top: 5),
                    width: 10,
                    height: 10,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.black,
                    ),
                  ),
                  hintText: "pick up",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                ),
              ),
            ),
          ),

          Positioned(
            top: 105.0,
            right: 15.0,
            left: 15.0,
            child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(1.0, 5.0),
                      blurRadius: 10,
                      spreadRadius: 3)
                ],
              ),
              child: TextField(
                cursorColor: Colors.black,
                controller: destinationController,
                textInputAction: TextInputAction.go,
                onSubmitted: (value) {
                  sendRequest(value);
                },
                decoration: InputDecoration(
                  icon: Container(
                    margin: EdgeInsets.only(left: 20, top: 5),
                    width: 10,
                    height: 10,
                    child: Icon(
                      Icons.local_taxi,
                      color: Colors.black,
                    ),
                  ),
                  hintText: "Destination?",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _placeDistance == null
                  ? SizedBox.shrink()
                  : Text(
                      "The Distance is : $_placeDistance km",
                      style: Theme.of(context).textTheme.headline6,
                    ),
            ),
          )

          // Positioned(
          //   top: 40,
          //   right: 10,
          //   child: FloatingActionButton(
          //     onPressed: _onAddMarkerPressed,
          //     tooltip: "addMap",
          //     backgroundColor: Colors.black,
          //     child: Icon(
          //       Icons.add_location,
          //       color: Colors.white,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  void onCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  getVets() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return await Firestore.instance.collection("veterinary").getDocuments();
  }

  void _addMarker(LatLng location, String address) {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(location.toString()),
          position: location,
          infoWindow: InfoWindow(title: address, snippet: "go here"),
          icon: BitmapDescriptor.defaultMarker));
    });
  }

  // ! TO CREATE ROUTE
  void createRoute(String encondedPoly) {
    setState(() {
      _polyLines.add(Polyline(
        polylineId: PolylineId(encondedPoly.toString()),
        width: 10,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.black,
      ));
    });
  }

  // ! CREATE LAGLNG LIST
  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    double totalDistance = 0.0;

    // Calculating the total distance by adding the distance
    // between small segments
    for (int i = 0; i < result.length - 1; i++) {
      totalDistance += _coordinateDistance(
        result[i].latitude,
        result[i].longitude,
        result[i + 1].latitude,
        result[i + 1].longitude,
      );
    }

    setState(() {
      _placeDistance = totalDistance.toStringAsFixed(2);
      print('DISTANCE: $_placeDistance km');
    });
    return result;
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // !DECODE POLY
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  // ! SEND REQUEST
  void sendRequest(String intendedLocation) async {
    List<geo.Placemark> placemark =
        await geo.Geolocator().placemarkFromAddress(intendedLocation);
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;
    LatLng destination = LatLng(latitude, longitude);
    _addMarker(destination, intendedLocation);
    String route = await _googleMapsServices.getRouteCoordinates(
      LatLng(latitudeCurrent, longitudeCurrent),
      destination,
    );
    createRoute(route);
  }
}
