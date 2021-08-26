import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_health_v2/constants/constants.dart';
import 'package:smart_health_v2/domain/location/models/directions.dart';

class DirectionService {
  static const _baseGoogleMapDirectionsUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  late Dio _dio;

  DirectionService() {
    _dio = Dio();
  }

  Future<Directions?> getDirections(
      LatLng startCoord, LatLng destinationCoord) async {
    final response =
        await _dio.get(_baseGoogleMapDirectionsUrl, queryParameters: {
      'origin': '${startCoord.latitude},${startCoord.longitude}',
      'destination':
          '${destinationCoord.latitude},${destinationCoord.longitude}',
      'key': googleMapKey
    });

    if (response.statusCode == 200) {
      return Directions.getDirectionsFromMap(response.data);
    }

    return null;
  }
}
