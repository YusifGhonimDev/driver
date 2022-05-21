import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetails {
  String? riderName, riderPhone, rideID, pickUp, destination, tripState;
  LatLng? pickUpLatLng, destinationLatLng;

  TripDetails({
    this.riderName,
    this.riderPhone,
    this.rideID,
    this.pickUp,
    this.destination,
    this.tripState,
    this.pickUpLatLng,
    this.destinationLatLng,
  });

  static TripDetails fromJson(Map<String, dynamic> json) {
    return TripDetails(
      riderName: json['riderName'],
      riderPhone: json['riderPhone'],
      rideID: json['rideID'],
      pickUp: json['pickUp'],
      destination: json['destination'],
      tripState: json['tripState'],
      pickUpLatLng: LatLng(
        json['pickUpLatitude'],
        json['pickUpLongitude'],
      ),
      destinationLatLng: LatLng(
        json['destinationLatitude'],
        json['destinationLongitude'],
      ),
    );
  }
}
