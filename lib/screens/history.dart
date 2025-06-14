import 'package:flutter/material.dart';
import 'package:mobile/widgets/app_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: const SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            // AppCard(
            //   title: 'Ambassador Mall Parking',
            //   subtitle: '123 Main St, Springfield, IL 62701',
            //   content: 'For 3 Hrs',
            //   rate: '25',
            // ),
            // AppCard(
            //   title: 'Bole International Airport',
            //   subtitle: '123 Main St, Springfield, IL 62701',
            //   content: 'For 3 Hrs',
            //   rate: '30',
            // ),
          ],
        ),
      )),
    );
  }
}
