part of 'authentication_cubit.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class DialogShown extends AuthenticationState {
  final String statusMessage;

  DialogShown(this.statusMessage);
}

class ErrorOccured extends AuthenticationState {
  final String errorMessage;

  ErrorOccured(this.errorMessage);
}

class AuthenticationSuccessful extends AuthenticationState {}
