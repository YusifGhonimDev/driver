import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsAPI {
  final _dio = Dio(BaseOptions(baseUrl: dotenv.env['GOOGLE_MAPS_ENDPOINT']!));
  final _mapsAPIKey = dotenv.env['API_KEY'];

  Future<Map<String, dynamic>> getDirectionDetails(
      LatLng originPoint, LatLng destinationPoint) async {
    try {
      Response response = await _dio.get(
          'directions/json?origin=${originPoint.latitude},${originPoint.longitude}&destination=${destinationPoint.latitude},${destinationPoint.longitude}&travelMode=driving&key=$_mapsAPIKey');

      return response.data;
    } catch (e) {
      return {};
    }
  }
}
