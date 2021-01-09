import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:toast/toast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _homeloc = "searching...";
  Position _currentPosition;
  String gmaploc="";
  CameraPosition _userpos;
  CameraPosition _home;
  double latitude=6.4676929;
  double longitude=100.5067673;
  Set<Marker> markers = Set();
  MarkerId markerId1 = MarkerId("12");
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController gmcontroller;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }


  @override
  Widget build(BuildContext context) {
    var alheight = MediaQuery.of(context).size.height;
    var alwidth = MediaQuery.of(context).size.width;
    try {
      _controller = Completer();
      _userpos = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 17,);
            return SafeArea(
              child: Scaffold(
                resizeToAvoidBottomPadding: false,
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(
                    "Choose Your Location",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  flexibleSpace: Image(
                    image: AssetImage("assests/appmap.jpg"),
                    fit: BoxFit.cover,
                  ),
                  actions: [
                    Flexible(
                      child: IconButton(
                        icon: Icon(
                          Icons.gps_fixed,
                          size: 24,
                          color: Colors.red,
                        ),
                      ),
                    )
                  ],
                ),
                body: SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assests/Map.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              height: alheight-230,
                              width: alwidth-50,
                              child: GoogleMap(
                                  mapType: MapType.normal,
                                  initialCameraPosition: _userpos,
                                  markers: markers.toSet(),
                                  onMapCreated: (controller) {
                                    _controller.complete(controller);
                                  },
                                  onTap: (newLatLng) {
                                    _loadLoc(newLatLng);
                                  }),
                            ),
                            SizedBox(height: 10),
                            Stack(
                              children: [
                                Center(
                                  child:Container(
                                    height: 140,
                                    width: 320,
                                    child: new Container(
                                      decoration: new BoxDecoration(
                                        image: new DecorationImage(
                                          image: new AssetImage("assests/appmap.jpg"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Container(
                                              child:Text(
                                                  "Your latest address :",
                                                  style: TextStyle(color: Colors.black, fontSize: 14,
                                                      fontWeight: FontWeight.bold)
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      child: Text(
                                        _homeloc,
                                        style: TextStyle(color: Colors.black, fontSize: 12),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      child: Text(
                                        "Your current latitude:",
                                        style: TextStyle(color: Colors.black, fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        latitude.toString(),
                                        style: TextStyle(color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      child: Text(
                                        "Your current longitude:",
                                        style: TextStyle(color: Colors.black, fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        longitude.toString(),
                                        style: TextStyle(color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
              ),
            );
  } catch (e) {
    print(e);
  }
  }


  void _loadLoc(LatLng loc) async {
      markers.clear();
      latitude = loc.latitude;
      longitude = loc.longitude;
      _getLocationfromlatlng(latitude, longitude);
      _home = CameraPosition(
        target: loc,
        zoom: 17,
      );
      markers.add(Marker(
        markerId: markerId1,
        position: LatLng(latitude, longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      ));
    _userpos = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 17,
    );
  }

  _getLocationfromlatlng(double lat, double lng) async {
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(lat, lng);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
      _homeloc = first.addressLine;

    setState(() {
      _homeloc = first.addressLine;
    });
  }

  Future<void> _getLocation() async {
    try {
      var position= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
          setState(() async {
            print(position);
            markers.add(Marker(
              markerId: markerId1,
              position: LatLng(latitude, longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
            ));
            _currentPosition = position;
            if (_currentPosition != null) {
              final coordinates = new Coordinates(
                  _currentPosition.latitude, _currentPosition.longitude);
              var addresses =
                  await Geocoder.local.findAddressesFromCoordinates(coordinates);
              setState(() {
                var first = addresses.first;
                _homeloc = first.addressLine;
                if (_homeloc != null) {
                  latitude = _currentPosition.latitude;
                  longitude = _currentPosition.longitude;
                }
              });
            }
          });
    } catch (exception) {
      print(exception.toString());
    }
  }
}







