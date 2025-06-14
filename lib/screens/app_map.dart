import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile/models/lots.dart';

class AppMap extends StatefulWidget {
  final List<Lots> lots;
  final LatLng? userLocation;
  const AppMap({super.key, required this.lots, this.userLocation});

  @override
  State<AppMap> createState() => _AppMapState();
}

class _AppMapState extends State<AppMap> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: widget.userLocation ?? const LatLng(9.032834, 38.763358),
        initialZoom: 15,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: widget.lots
              .map((lot) => Marker(
                    width: 80,
                    height: 46,
                    point: LatLng(lot.latitude, lot.longitude),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.fromBorderSide(BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Text(
                              '99 ETB',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Transform.rotate(
                              angle: 3.14 / 4,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      right: BorderSide(
                                        width: 2,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      bottom: BorderSide(
                                        width: 2,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    )),
                                width: 10,
                                height: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
