import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'vehicle_info_state.dart';

class VehicleInfoCubit extends Cubit<VehicleInfoState> {
  VehicleInfoCubit() : super(VehicleInfoInitial());

  void setVehicleInfo(Map<String, dynamic> vehicleInfo) async {
    emit(DialogShown('Getting vehicle info'));
    if (await _isConnected()) {
      FirebaseFirestore.instance
          .collection('drivers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(vehicleInfo);
      emit(VehicleInfoSuccessful());
    } else {
      emit(ErrorOccured('No internet connection!'));
    }
  }

  Future<bool> _isConnected() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return false;
    } else {
      return true;
    }
  }
}
