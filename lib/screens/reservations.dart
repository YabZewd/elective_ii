import 'package:flutter/material.dart';
import 'package:mobile/widgets/app_card.dart';

class ReservationsScreen extends StatelessWidget {
  const ReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reservations'),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: const SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            // AppCard(
            //   title: 'Ambassador Mall Parking',
            //   subtitle: 'Jan 7, 8:43PM',
            //   isReservation: true,
            //   rate: '25',
            // ),
            // AppCard(
            //   title: 'Bole International Airport',
            //   subtitle: 'Jan 7, 8:43PM',
            //   isReservation: true,
            //   rate: '30',
            // ),
          ],
        ),
      )),
    );
  }
}
