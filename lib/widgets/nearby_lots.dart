import 'package:flutter/material.dart';

class NearbyLots extends StatelessWidget {
  final String parkingLot;
  final String rate;
  final String distance;

  const NearbyLots(
      {super.key,
      required this.parkingLot,
      required this.distance,
      required this.rate});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        parkingLot,
        style: const TextStyle(
            color: Color.fromRGBO(31, 32, 36, 1), fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('ETB $distance/hr'),
                  const Spacer(),
                  Text('ETB $rate/hr'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
