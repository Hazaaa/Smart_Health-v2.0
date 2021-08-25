import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationService with ChangeNotifier {
  Location location = new Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  LocationData get locationData => _locationData;

  Future<void> getLocation() async {
    bool _isServiceEnabled = await isServiceEnabled();
    bool _isPermissionGranted = await isPermissionGranted();
    _locationData = await location.getLocation();
    notifyListeners();
  }

  Stream<LocationData> getLocationOnChangeStream() {
    isServiceEnabled();
    isPermissionGranted();
    return location.onLocationChanged;
  }

  Future<bool> isServiceEnabled() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }
    return true;
  }

  Future<bool> isPermissionGranted() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }
}
