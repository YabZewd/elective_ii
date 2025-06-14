import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/models/lots.dart';
import 'package:mobile/services/location_service.dart';
import 'package:mobile/services/parking_lots.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<FetchLocation>(
      (event, emit) async {
        try {
          print('i am trying to get a location');
          final pos = await LocationService.getCurrentLocation();
          print('pos: $pos');
          if (pos == null) {
            emit(LocationError(
                'Location not available. Please enable location services and permissions.'));
          } else {
            emit(LocationLoaded(
                latitude: pos.latitude, longitude: pos.longitude));
            add(FetchParkingLots(
                latitude: pos.latitude, longitude: pos.longitude));
          }
        } catch (e) {
          print('Loading location: $e');
          emit(LocationError(e.toString()));
        }
      },
    );
    on<FetchParkingLots>((event, emit) async {
      try {
        final List<Lots> lots = await fetchParkingLots(
          event.latitude,
          event.longitude,
        ); // You may want to pass lat/lng if your API supports it
        emit(ParkingLotsLoaded(lots));
      } catch (e) {
        print('fetching lots: $e');

        emit(LocationError(e.toString()));
      }
    });
    on<FetchParkingLotsWithSort>((event, emit) async {
      try {
        final List<Lots> lots = await fetchParkingLots(
          event.latitude,
          event.longitude,
          sortBy: event.sortBy,
        );
        emit(ParkingLotsLoaded(lots));
      } catch (e) {
        emit(LocationError(e.toString()));
      }
    });

    on<UpdateLocation>((event, emit) {
      emit(
          LocationLoaded(latitude: event.latitude, longitude: event.longitude));
    });
  }
}
