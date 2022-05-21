part of 'vehicle_info_cubit.dart';

@immutable
abstract class VehicleInfoState {}

class VehicleInfoInitial extends VehicleInfoState {}

class DialogShown extends VehicleInfoState {
  final String statusMessage;

  DialogShown(this.statusMessage);
}

class ErrorOccured extends VehicleInfoState {
  final String errorMessage;

  ErrorOccured(this.errorMessage);
}

class VehicleInfoSuccessful extends VehicleInfoState {}
