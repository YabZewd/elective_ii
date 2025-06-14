part of 'location_bloc.dart';

sealed class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoaded extends LocationState {
  final double latitude;
  final double longitude;
  LocationLoaded({required this.latitude, required this.longitude});
}

class ParkingLotsLoaded extends LocationState {
  final List<Lots> lots;
  ParkingLotsLoaded(this.lots);
}

class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}
