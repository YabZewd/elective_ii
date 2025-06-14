import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile/bloc/locations/location_bloc.dart';
import 'package:mobile/models/lots.dart';
import 'package:mobile/screens/app_map.dart';
import 'package:mobile/widgets/app_dragable_sheet.dart';

import 'package:mobile/widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double appBarHeight = 80;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: appBarHeight,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext innerContext) {
            return Container(
              margin: const EdgeInsets.only(left: 8),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(innerContext).primaryColor.withAlpha(128),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(innerContext).openDrawer();
                },
                iconSize: 32,
                splashRadius: 22,
              ),
            );
          },
        ),
      ),
      drawer: const AppDrawer(),
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          List<Lots> markedLots = [];
          if (state is ParkingLotsLoaded) {
            markedLots = state.lots;
          }
          LatLng? userLocation;
          if (state is LocationLoaded) {
            userLocation = LatLng(state.latitude, state.longitude);
          } else if (state is ParkingLotsLoaded) {
            final locationState = context.read<LocationBloc>().state;
            if (locationState is LocationLoaded) {
              userLocation =
                  LatLng(locationState.latitude, locationState.longitude);
            }
          }
          return Stack(
            children: <Widget>[
              AppMap(
                lots: markedLots,
                userLocation: userLocation,
              ),
              Positioned(
                  top: statusBarHeight + appBarHeight,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: const AppDragableSheet()),
            ],
          );
        },
      ),
    );
  }
}
