part of 'location_bloc.dart';

sealed class LocationEvent {}

class FetchLocation extends LocationEvent {}

class UpdateLocation extends LocationEvent {
  final double latitude;
  final double longitude;
  UpdateLocation({required this.latitude, required this.longitude});
}

class FetchParkingLots extends LocationEvent {
  final double latitude;
  final double longitude;
  FetchParkingLots({required this.latitude, required this.longitude});
}

class FetchParkingLotsWithSort extends LocationEvent {
  final double latitude;
  final double longitude;
  final String sortBy;
  FetchParkingLotsWithSort({required this.latitude, required this.longitude, required this.sortBy});
}
