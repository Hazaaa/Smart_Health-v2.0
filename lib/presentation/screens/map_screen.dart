import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_health_v2/domain/location/direction_service.dart';
import 'package:smart_health_v2/domain/location/models/directions.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:smart_health_v2/constants/constants.dart';
import 'package:smart_health_v2/constants/icons_config.dart';
import 'package:smart_health_v2/constants/size_confige.dart';
import 'package:smart_health_v2/domain/auth/auth_service.dart';
import 'package:smart_health_v2/domain/data/database.dart';
import 'package:smart_health_v2/domain/location/location_service.dart';
import 'package:smart_health_v2/models/pharmacy.dart';

class MapScreen extends StatefulWidget {
  final bool pickingPharmacy;
  final Function? requestFunction;
  final String? selectedPharmacyId;
  MapScreen(
      {this.pickingPharmacy = false,
      this.requestFunction,
      this.selectedPharmacyId});

  @override
  _MapScreenState createState() =>
      _MapScreenState(pickingPharmacy, requestFunction, selectedPharmacyId);
}

class _MapScreenState extends State<MapScreen> {
  final bool pickingPharmacy;
  final Function? requestFunction;
  final String? selectedPharmacyId;
  Completer<GoogleMapController> _controller = Completer();
  LocationService locationService = LocationService();
  bool _liveTracking = false;
  StreamSubscription<LocationData>? locationOnChangeStream;
  CameraPosition? homeCameraPosition;
  LatLng? homeCoords;
  List<Marker> markers = [];
  BitmapDescriptor? homeIcon;
  BitmapDescriptor? pharmacyIcon;
  bool _showOnlyPharmacies = false;
  List<Pharmacy> pharmacies = [];
  double floatingButtonSize = 60.0;
  Pharmacy? selectedPharmacy;
  bool isPharmacySelected = false;
  DirectionService directionService = DirectionService();
  Directions? _directionInfo;
  bool showingDirection = false;

  _MapScreenState(
      this.pickingPharmacy, this.requestFunction, this.selectedPharmacyId);

  @override
  void initState() {
    super.initState();
    homeIcon = IconsConfig.homeIcon!;
    pharmacyIcon = IconsConfig.pharmacyIcon!;
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);

    if (pharmacies.length == 0) {
      _getPharmacies(db);
    }

    return SafeArea(
      child: Scaffold(
        body: Consumer<AuthService>(builder: (context, authService, snapshot) {
          return Stack(
            children: [
              // GOOGLE MAP
              GoogleMap(
                initialCameraPosition: _getHomeCameraPosition(
                    authService.currentUser!.userDetails.homeCoords),
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  if (homeCoords != null) {
                    setState(() {
                      markers.add(Marker(
                          markerId: MarkerId("home_marker"),
                          infoWindow: InfoWindow(title: "Ku??a"),
                          position: homeCoords!,
                          icon: homeIcon!));
                    });
                  }

                  if (selectedPharmacyId != null && selectedPharmacy != null) {
                    _moveCameraToSelectedPharmacy();
                  }
                },
                markers: markers.toSet(),
                polylines: {
                  if (_directionInfo != null)
                    Polyline(
                        polylineId: PolylineId('direction_polyline'),
                        color: Colors.red,
                        width: 5,
                        points: _directionInfo!.polylinePoints
                            .map((e) => LatLng(e.latitude, e.longitude))
                            .toList())
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
                compassEnabled: false,
              ),

              // APP BAR WIDGET
              Visibility(
                visible: pickingPharmacy,
                child: _buildAppBar(),
              ),

              // DETAILS WIDGET
              Visibility(
                visible: isPharmacySelected,
                child: _buildPharmacyDetailWidget(),
              ),
              Positioned(
                top: 150.0,
                left: SizeConfig.screenWidth / 3,
                child: Visibility(
                  visible: showingDirection,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(FontAwesomeIcons.locationArrow, size: 14.0),
                            Container(
                              margin: EdgeInsets.only(left: 5.0, top: 2.0),
                              child: Text(
                                  "Udaljenost: ${showingDirection ? _directionInfo!.totalDistance : ''}"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(FontAwesomeIcons.stopwatch, size: 14.0),
                            Container(
                              margin: EdgeInsets.only(left: 5.0, top: 3.0),
                              child: Text(
                                  "Vreme: ${showingDirection ? _directionInfo!.totalDuration : ''}"),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    right: 10.0, bottom: floatingButtonSize + 20.0),
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: _toogleLiveLocation,
                  backgroundColor: _liveTracking ? Colors.red : Colors.green,
                  child: Icon(_liveTracking
                      ? Icons.location_disabled_rounded
                      : Icons.my_location_rounded),
                  tooltip: _liveTracking
                      ? "Ugasi u??ivo pra??enje"
                      : "Upali u??ivo pra??enje",
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10.0, bottom: 10.0),
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
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
                  tooltip: "Prika??i ku??u",
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  margin: EdgeInsets.only(left: 10.0, bottom: 15.0),
                  width: 200.0,
                  height: 40.0,
                  padding: EdgeInsets.only(left: 15.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.teal.shade400),
                  child: Row(
                    children: [
                      Text(
                        "Prika??i samo apoteke:",
                        style: TextStyle(color: Colors.white),
                      ),
                      Checkbox(
                          activeColor: Colors.white,
                          checkColor: Colors.black,
                          value: _showOnlyPharmacies,
                          onChanged: _toggleMapStyle)
                    ],
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Future<void> _moveCameraToUserHome() async {
    final GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(homeCameraPosition!));
  }

  Future<void> _moveCameraToSelectedPharmacy() async {
    final GoogleMapController controller = await _controller.future;

    if (selectedPharmacy != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(selectedPharmacy!.coords.latitude,
              selectedPharmacy!.coords.longitude),
          zoom: 16.0)));
    }
  }

  CameraPosition _getHomeCameraPosition(GeoPoint _homeCoords) {
    if (homeCameraPosition == null) {
      homeCoords = LatLng(_homeCoords.latitude, _homeCoords.longitude);
      homeCameraPosition = CameraPosition(target: homeCoords!, zoom: 16);
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
                  target: LatLng(l.latitude!, l.longitude!), zoom: 18),
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

  void _getPharmacies(Database db) {
    db.pharmaciesCollection.getData().then((value) {
      pharmacies.clear();
      value.docs.forEach((element) {
        final newPharmacy = Pharmacy.fromJson(element);
        newPharmacy.id = element.id;
        pharmacies.add(newPharmacy);
      });

      setState(() {
        pharmacies.forEach((pharmacy) {
          markers.add(
            Marker(
                markerId: MarkerId("pharmacy_${pharmacy.name}"),
                position:
                    LatLng(pharmacy.coords.latitude, pharmacy.coords.longitude),
                icon: pharmacyIcon!,
                onTap: () {
                  setState(() {
                    isPharmacySelected = true;
                    selectedPharmacy = pharmacy;
                  });
                }),
          );
        });

        if (selectedPharmacyId != null) {
          selectedPharmacy = pharmacies
              .where((element) => element.id == selectedPharmacyId!)
              .first;
          isPharmacySelected = true;
        }
      });
    });
  }

  Future<void> _toggleMapStyle(bool? value) async {
    _showOnlyPharmacies = value!;
    final GoogleMapController controller = await _controller.future;

    setState(() {
      if (_showOnlyPharmacies) {
        controller.setMapStyle(googleMapCustomStyle);
      } else {
        controller.setMapStyle(null);
      }
    });
  }

  Widget _buildPharmacyDetailWidget() {
    return Container(
      height: 130.0,
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.only(
          top: pickingPharmacy ? 65.0 : 15.0,
          left: 15.0,
          right: 15.0,
          bottom: 15.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
      child: Stack(
        children: [
          Positioned(
            top: 8.0,
            right: 10.0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isPharmacySelected = false;
                  selectedPharmacy = null;
                  _directionInfo = null;
                  showingDirection = false;
                });
              },
              child: Icon(FontAwesomeIcons.times, size: 18.0),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 8.0),
              Text(
                selectedPharmacy == null
                    ? ''
                    : "Apoteka: ${selectedPharmacy!.name}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                    color: Colors.black87),
              ),
              SizedBox(height: 3.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.mapMarkerAlt,
                    size: 18.0,
                  ),
                  SizedBox(width: 5.0),
                  Container(
                    margin: EdgeInsets.only(top: 2.0),
                    child: Text(
                      selectedPharmacy == null
                          ? ''
                          : "${selectedPharmacy!.address}",
                      style: TextStyle(fontSize: 14.0, color: Colors.black87),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.clock,
                    size: 18.0,
                  ),
                  SizedBox(width: 5.0),
                  Container(
                    margin: EdgeInsets.only(top: 2.0),
                    child: Text(
                      selectedPharmacy == null
                          ? ''
                          : "${selectedPharmacy!.workingHours}",
                      style: TextStyle(fontSize: 14.0, color: Colors.black87),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Visibility(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: pickingPharmacy,
                      child: Container(
                        height: 24.0,
                        width: 115.0,
                        child: ElevatedButton.icon(
                          icon: Icon(FontAwesomeIcons.handHoldingMedical,
                              size: 13.0),
                          label: Text(
                            "Pokupi ovde",
                            style: TextStyle(fontSize: 12.0),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          onPressed: () {
                            requestFunction!(selectedPharmacy!.id,
                                selectedPharmacy!.deviceToken);
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !pickingPharmacy,
                      child: Container(
                        height: 24.0,
                        width: 110.0,
                        child: ElevatedButton.icon(
                          icon: Icon(FontAwesomeIcons.phone, size: 13.0),
                          label: Text(
                            "Pozovi",
                            style: TextStyle(fontSize: 12.0),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                          ),
                          onPressed: () {
                            if (selectedPharmacy != null) {
                              urlLauncher.launch(
                                  "tel:${selectedPharmacy!.phoneNumber}");
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Visibility(
                      visible: !pickingPharmacy,
                      child: Container(
                        height: 24.0,
                        width: 110.0,
                        child: ElevatedButton.icon(
                          icon: Icon(FontAwesomeIcons.directions, size: 13.0),
                          label: Text(
                            !showingDirection ? "Prika??i put" : "Sakrij put",
                            style: TextStyle(fontSize: 12.0),
                          ),
                          onPressed: () {
                            if (!showingDirection) {
                              _showDirections();
                            } else {
                              setState(() {
                                _directionInfo = null;
                                showingDirection = false;
                              });
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
        height: 50,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          children: [
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(right: 15.0, left: 10.0),
                child: GestureDetector(
                  child: Icon(Icons.arrow_back_ios_rounded),
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ),
            Text("Izaberite apoteku gde biste pokupili lekove:",
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
          ],
        ));
  }

  Future<void> _showDirections() async {
    final GoogleMapController controller = await _controller.future;
    final userCurrentLocation = await locationService.getLocation();
    final userCoords =
        LatLng(userCurrentLocation.latitude!, userCurrentLocation.longitude!);
    final directions = await directionService.getDirections(
        userCoords,
        LatLng(selectedPharmacy!.coords.latitude,
            selectedPharmacy!.coords.longitude));

    setState(() {
      controller
          .animateCamera(CameraUpdate.newLatLngBounds(directions!.bounds, 100));
      showingDirection = true;
      _directionInfo = directions;
    });
  }
}
