part of 'maps_cubit.dart';

@immutable
abstract class MapsState {}

class MapsInitial extends MapsState {}

class MapsLoaded extends MapsState {
  final LatLng currentPosition;

  MapsLoaded(this.currentPosition);
}

class GoOnline extends MapsState {}

class GoOffline extends MapsState {}

class ShowDialog extends MapsState {
  final String status;

  ShowDialog(this.status);
}

class DetailsLoaded extends MapsState {}

class TripReceived extends MapsState {
  final TripDetails details;

  TripReceived(this.details);
}

class TripLoaded extends MapsState {
  final String polylinePoint;
  final Set<Marker> markers;
  final LatLng currentLatLng;

  TripLoaded(this.polylinePoint, this.markers, this.currentLatLng);
}

class DriverArrived extends MapsState {
  final String durationText;
  final String title;
  final Color titleColor;

  DriverArrived({
    required this.durationText,
    required this.title,
    required this.titleColor,
  });
}

class TripEnded extends MapsState {
  final String totalFare;

  TripEnded(this.totalFare);
}

class CashCollected extends MapsState {}
