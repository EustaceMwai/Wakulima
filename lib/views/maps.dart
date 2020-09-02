import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  GoogleMapController mapController;
  static const _initialPosition = LatLng(12.97, 77.58);
  LatLng _lastPosition = _initialPosition;
  final Set<Marker> _markers = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: _initialPosition, zoom: 20),
            onMapCreated: onCreated,
            myLocationEnabled: true,
            mapType: MapType.normal,
            compassEnabled: true,
            markers: _markers,
            onCameraMove: _onCameraMove,
          ),
          Positioned(
            top: 40,
            right: 10,
            child: FloatingActionButton(
              onPressed: _onAddMarkerPressed,
              tooltip: "addMap",
              backgroundColor: Colors.black,
              child: Icon(
                Icons.add_location,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  void onCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _lastPosition = position.target;
    });
  }

  void _onAddMarkerPressed() {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(_lastPosition.toString()),
          position: _lastPosition,
          infoWindow: InfoWindow(title: "Remember here", snippet: "good place"),
          icon: BitmapDescriptor.defaultMarker));
    });
  }
}
