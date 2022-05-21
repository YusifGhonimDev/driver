import 'package:driver/data/models/direction_details.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../api/maps_api.dart';

class MapsRepository {
  final _mapsAPI = MapsAPI();

  Future<DirectionDetails> getDirectionDetails(
      LatLng originPoint, LatLng destinationPoint) async {
    Map<String, dynamic> json =
        await _mapsAPI.getDirectionDetails(originPoint, destinationPoint);
    return DirectionDetails.fromJson(json);
  }
}
