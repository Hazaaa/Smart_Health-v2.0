import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_health_v2/constants/constants.dart';
import 'package:smart_health_v2/domain/location/location_service.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  LocationService locationService = LocationService();

  static final CameraPosition _homePosition = CameraPosition(
      target: LatLng(43.33160566750162, 21.892302632331848), zoom: 18.0);

  // READ HOME COORDS FROM AUTHENTICATED USER

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: GoogleMap(
              initialCameraPosition: _homePosition,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                locationService.getLocationOnChangeStream().listen((l) {
                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: LatLng(l.latitude!, l.longitude!), zoom: 17),
                    ),
                  );
                });
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: _moveCameraToUserHome,
                  child: Container(
                    height: 60,
                    width: 60,
                    child: Icon(Icons.home),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          kPrimarylightColor,
                          kPrimaryDarkColor,
                        ],
                      ),
                    ),
                  ),
                  tooltip: "Show home",
                ),
              ],
            )));
  }

  void _moveCameraToUserHome() {}
}
