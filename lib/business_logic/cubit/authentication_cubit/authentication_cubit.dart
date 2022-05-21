import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:driver/data/models/driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  void loginDriver(Driver driverInfo) async {
    emit(DialogShown('Logging you in'));
    if (await _isConnected()) {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: driverInfo.email!, password: driverInfo.password!)
          .catchError((error) {
        FirebaseAuthException exception = error;
        emit(ErrorOccured(exception.message!));
      });
      emit(AuthenticationSuccessful());
    } else {
      emit(ErrorOccured('No internet connection!'));
    }
  }

  void registerDriver(Driver driverInfo) async {
    emit(DialogShown('Registering you in'));
    if (await _isConnected()) {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: driverInfo.email!, password: driverInfo.password!)
          .catchError((error) {
        FirebaseAuthException exception = error;
        emit(ErrorOccured(exception.message!));
      });
      FirebaseFirestore.instance
          .collection('drivers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'full_name': driverInfo.name,
        'email': driverInfo.email,
        'phone_number': driverInfo.phoneNumber,
      });
      emit(AuthenticationSuccessful());
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
