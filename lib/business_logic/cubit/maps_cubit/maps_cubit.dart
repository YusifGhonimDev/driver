import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../constants/colors.dart';
import '../../../data/models/trip_details.dart';
import '../../../data/repositories/maps_repository.dart';

part 'maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  final _repository = MapsRepository();
  final _geo = Geoflutterfire();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  Position? _currentPosition;
  LatLng? currentLatLng, _driverLatLng;
  bool isAvailable = false;
  String availibilityTitle = 'GO ONLINE';
  Color availibilityColor = colorOrange;
  StreamSubscription<Position>? _positionStream;
  TripDetails trip = TripDetails();
  Set<Marker> _markers = {};

  MapsCubit() : super(MapsInitial());

  void endTrip(TripDetails tripDetails) {
    _firestore
        .collection('rideDetails')
        .doc(tripDetails.rideID)
        .get()
        .then((snapshot) => emit(TripEnded(snapshot.data()!['tripFare'])));
  }

  void cashCollected(TripDetails tripDetails) {
    _firestore.collection('rideDetails').doc(tripDetails.rideID).delete();
    emit(CashCollected());
  }

  void arrived(TripDetails tripDetails) {
    LocationSettings locationSettings =
        const LocationSettings(accuracy: LocationAccuracy.bestForNavigation);
    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (position) {
        _driverLatLng = LatLng(position.latitude, position.longitude);
        _repository
            .getDirectionDetails(_driverLatLng!, tripDetails.destinationLatLng!)
            .then((directionDetails) {
          _firestore
              .collection('rideDetails')
              .doc(tripDetails.rideID)
              .update({'tripState': 'ARRIVED'});
          emit(
            DriverArrived(
                durationText: directionDetails.durationText!,
                title: 'END TRIP',
                titleColor: Colors.red.shade900),
          );
        });
      },
    );
  }

  void getDirectionDetails(LatLng originPoint, LatLng destinationPoint) {
    _repository
        .getDirectionDetails(originPoint, destinationPoint)
        .then((directionDetails) {
      _markers = _getMarkers(originPoint, destinationPoint);
      Geolocator.getPositionStream(
              locationSettings: const LocationSettings(
                  accuracy: LocationAccuracy.bestForNavigation))
          .listen(
        (Position position) async {
          currentLatLng = LatLng(position.latitude, position.longitude);
          await _addDriverMarkerToMap(position);
          emit(TripLoaded(
              directionDetails.polylinePoints!, _markers, currentLatLng!));
        },
      );
    });
  }

  Future<void> _addDriverMarkerToMap(Position position) async {
    Marker driverMarker = Marker(
      markerId: const MarkerId('Moving'),
      position: LatLng(position.latitude, position.longitude),
      icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(4, 4)), 'images/car1.png'),
    );
    _markers.removeWhere((marker) => marker.markerId.value == 'Moving');
    _markers.add(driverMarker);
  }

  void loadMap() async {
    LatLng currentPosition = await getCurrentPosition();
    emit(MapsLoaded(currentPosition));
  }

  Future<LatLng> getCurrentPosition() async {
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    LatLng currentPosition = LatLng(position.latitude, position.longitude);
    return currentPosition;
  }

  Future<void> goOnline() async {
    LatLng currentPosition = await getCurrentPosition();
    _geo.point(
        latitude: currentPosition.latitude,
        longitude: currentPosition.longitude);
    _updateLocation();
    _toggleAvailability();
    emit(GoOnline());
    _manageTrips();
  }

  void goOffline() {
    _toggleAvailability();
    _positionStream!.cancel();
    _deleteDriverLocation();
    emit(GoOffline());
  }

  void _deleteDriverLocation() {
    _firestore.collection('drivers').doc(_auth.currentUser!.uid).update(
      {'position': FieldValue.delete()},
    );
  }

  void _toggleAvailability() {
    isAvailable = !isAvailable;
    isAvailable
        ? availibilityTitle = 'GO OFFLINE'
        : availibilityTitle = 'GO ONLINE';
    isAvailable
        ? availibilityColor = colorGreen
        : availibilityColor = colorOrange;
  }

  void _updateLocation() {
    LocationSettings locationSettings =
        const LocationSettings(accuracy: LocationAccuracy.bestForNavigation);
    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
        _currentPosition = position;
        GeoFirePoint currentLocation = _geo.point(
            latitude: _currentPosition!.latitude,
            longitude: _currentPosition!.longitude);
        _firestore
            .collection('drivers')
            .doc(_auth.currentUser!.uid)
            .update({'position': currentLocation.data});
      },
    );
  }

  void _manageTrips() {
    _firestore.collection('rideDetails').get().then((rideDetails) async {
      List<TripDetails> trips = [];
      final currentPosition = await getCurrentPosition();
      final currentLat = currentPosition.latitude;
      final currentLng = currentPosition.longitude;
      for (var ride in rideDetails.docs) {
        final trip = TripDetails.fromJson(ride.data());
        GeoFirePoint riderLocation = _geo.point(
            latitude: trip.pickUpLatLng!.latitude,
            longitude: trip.pickUpLatLng!.longitude);
        final tripKm = _calculateTripKm(riderLocation, currentLat, currentLng);
        if (tripKm <= 10) {
          trips.add(trip);
        }
      }
      if (trips.isNotEmpty) {
        for (var trip in trips) {
          if (trip.tripState == 'WAITING') {
            emit(TripReceived(trip));
          }
        }
      }
    });
  }

  void tripAccepted(rideID) {
    LocationSettings locationSettings =
        const LocationSettings(accuracy: LocationAccuracy.bestForNavigation);
    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
        _currentPosition = position;
        GeoFirePoint currentLocation = _geo.point(
            latitude: _currentPosition!.latitude,
            longitude: _currentPosition!.longitude);
        _firestore
            .collection('rideDetails')
            .doc(rideID)
            .update({'driverPosition': currentLocation.data});
      },
    );
    _firestore
        .collection('rideDetails')
        .doc(rideID)
        .update({'tripState': 'ACCEPTED'});
    _firestore.collection('rideDetails').doc(rideID).get().then((rideDetails) {
      trip = TripDetails.fromJson(rideDetails.data()!);
    });
  }

  double _calculateTripKm(
          GeoFirePoint riderLocation, double currentLat, double currentLng) =>
      riderLocation.kmDistance(lat: currentLat, lng: currentLng);

  Set<Marker> _getMarkers(LatLng pickUpLatLng, LatLng destinationLatLng) {
    Marker originMarker = Marker(
      markerId: const MarkerId('1'),
      position: pickUpLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );
    Marker destinationMarker = Marker(
      markerId: const MarkerId('2'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    return {originMarker, destinationMarker};
  }
}
