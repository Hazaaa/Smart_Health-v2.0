import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:smart_health_v2/constants/constants.dart';
import 'package:smart_health_v2/domain/auth/auth_service.dart';
import 'package:smart_health_v2/domain/location/location_service.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  LocationService locationService = LocationService();
  bool _liveTracking = false;
  StreamSubscription<LocationData>? locationOnChangeStream;
  CameraPosition? homeCameraPosition;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Consumer<AuthService>(
                builder: (context, authService, snapshot) {
              return GoogleMap(
                initialCameraPosition: _getHomeCameraPosition(
                    authService.currentUser!.userDetails.homeCoords),
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
              );
            }),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: _toogleLiveLocation,
                  backgroundColor: _liveTracking ? Colors.red : Colors.green,
                  child: Icon(_liveTracking
                      ? Icons.location_disabled_rounded
                      : Icons.my_location_rounded),
                  tooltip: _liveTracking
                      ? "Turn off live tracking"
                      : "Turn on live tracking",
                ),
                SizedBox(
                  height: 10.0,
                ),
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

  Future<void> _moveCameraToUserHome() async {
    final GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(homeCameraPosition!));
  }

  CameraPosition _getHomeCameraPosition(GeoPoint homeCoords) {
    if (homeCameraPosition == null) {
      homeCameraPosition = CameraPosition(
          target: LatLng(homeCoords.latitude, homeCoords.longitude), zoom: 17);
    }
    return homeCameraPosition!;
  }

  Future<void> _toogleLiveLocation() async {
    final GoogleMapController controller = await _controller.future;
    setState(() {
      _liveTracking = !_liveTracking;
      if (_liveTracking) {
        locationOnChangeStream =
            locationService.getLocationOnChangeStream().listen((l) {
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(l.latitude!, l.longitude!), zoom: 17),
            ),
          );
        });
      } else {
        if (locationOnChangeStream != null) {
          locationOnChangeStream?.cancel();
        }
      }
    });
  }
}
