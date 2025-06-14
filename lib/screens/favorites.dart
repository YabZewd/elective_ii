import 'package:flutter/material.dart';
import 'package:mobile/screens/parking_spot.dart';
import 'package:mobile/widgets/app_card.dart';
import 'package:mobile/services/favorite_service.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Getting your favorite lots...'),
                SizedBox(height: 16),
                CircularProgressIndicator(),
              ],
            ));
          } else if (snapshot.hasError) {
            print('there is an error here');
            print('in snapshot: ${snapshot.data}');
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorites found.'));
          }
          final favorites = snapshot.data!;
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final lot = favorites[index];
              return AppCard(
                title: lot.name,
                subtitle: (lot.address!.isNotEmpty)
                    ? lot.address
                    : (lot.description ?? ''),
                imageUrl: (lot.images.isNotEmpty &&
                        lot.images[0] != null &&
                        (lot.images[0] is String) &&
                        (lot.images[0] as String).isNotEmpty)
                    ? lot.images[0] as String
                    : null,
                content: lot.description,
                lot: lot,
                rate: '',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ParkingSpotScreen(lot: lot),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
