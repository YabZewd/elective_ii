import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile/bloc/locations/location_bloc.dart';
import 'package:mobile/services/location_service.dart';
import 'package:mobile/screens/parking_spot.dart';
import 'package:mobile/utils/getters.dart';

class AppDragableSheet extends StatefulWidget {
  const AppDragableSheet({super.key});
  @override
  State<AppDragableSheet> createState() => _AppDragableSheetState();
}

class _AppDragableSheetState extends State<AppDragableSheet>
    with WidgetsBindingObserver {
  final List<String> dropdownItems = <String>['distance', 'price'];
  String dropdownValue = 'distance';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<LocationBloc>().add(FetchLocation());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<LocationBloc>().add(FetchLocation());
    }
  }

  Widget _nearbyContent(BuildContext context, LocationState state) => Container(
        padding: const EdgeInsets.all(36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Allow Location Access to Find Parking Lots Near You!',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: () async {
                  if (state is LocationError) {
                    Geolocator.openAppSettings();
                  } else {
                    await LocationService.getCurrentLocation();
                  }
                },
                child: const Text(
                  'Turn On Location Services',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(),
                ))
          ],
        ),
      );

  void _onFilterChanged(String value) {
    setState(() {
      dropdownValue = value;
    });

    final locationState = context.read<LocationBloc>().state;
    double? lat;
    double? lng;
    if (locationState is LocationLoaded) {
      lat = locationState.latitude;
      lng = locationState.longitude;
    } else if (locationState is ParkingLotsLoaded &&
        locationState.lots.isNotEmpty) {
      lat = locationState.lots.first.latitude;
      lng = locationState.lots.first.longitude;
    }
    if (lat != null && lng != null) {
      context.read<LocationBloc>().add(FetchParkingLotsWithSort(
            latitude: lat,
            longitude: lng,
            sortBy: dropdownValue,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black26)],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Container(
                    width: 96,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(232, 239, 240, 1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  style: TextStyle(color: Theme.of(context).primaryColor),
                  decoration: InputDecoration(
                    hintText: 'Search…',
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).primaryColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Parking Lots Nearby",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(
                        Icons.filter_alt_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      onChanged: (String? value) {
                        if (value != null) {
                          _onFilterChanged(value);
                        }
                      },
                      items: dropdownItems
                          .map<DropdownMenuItem<String>>((String val) {
                        return DropdownMenuItem<String>(
                            value: val,
                            child: Text(
                              val,
                              style: const TextStyle(fontSize: 15),
                            ));
                      }).toList(),
                    )
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<LocationBloc, LocationState>(
                  builder: (context, state) {
                    if (state is LocationInitial) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is LocationError) {
                      return _nearbyContent(context, state);
                    } else if (state is ParkingLotsLoaded) {
                      final nearbyLots = state.lots;
                      if (nearbyLots.isEmpty) {
                        return const Center(
                            child: Text('No parking lots found.'));
                      }
                      return ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                        itemCount: nearbyLots.length,
                        itemBuilder: (context, index) {
                          final lot = nearbyLots[index];
                          print('error here?');
                          return ListTile(
                            leading: SizedBox(
                              width: 48,
                              height: 56,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image(
                                  image: getLotImageProvider(
                                    (lot.images.isNotEmpty &&
                                            lot.images[0] != null &&
                                            lot.images[0] is String &&
                                            (lot.images[0] as String)
                                                .isNotEmpty)
                                        ? lot.images[0] as String
                                        : null,
                                  ),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    debugPrint(
                                        'Image loading failed for URL: ${(lot.images.isNotEmpty && lot.images[0] != null) ? lot.images[0] : null}. Error: $error');
                                    return Image.asset(
                                      'assets/images/placeholder_image.png',
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                    );
                                  },
                                ),
                              ),
                            ),
                            title: Text(lot.name),
                            subtitle: Text(
                              lot.address ?? '',
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ParkingSpotScreen(lot: lot),
                                ),
                              );
                            },
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(
                          color: Color.fromRGBO(232, 239, 240, 1),
                        ),
                      );
                    }
                    // Show loading or initial state
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              'Please wait while we fetch parking lots nearby!'),
                          SizedBox(height: 16),
                          CircularProgressIndicator(),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
