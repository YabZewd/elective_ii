import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile/models/lots.dart';
import 'package:mobile/utils/getters.dart';
import 'package:mobile/widgets/reviews.dart';
import 'package:mobile/services/favorite_service.dart';

class ParkingSpotScreen extends StatefulWidget {
  final Lots lot;
  const ParkingSpotScreen({super.key, required this.lot});

  @override
  State<ParkingSpotScreen> createState() => _ParkingSpotScreenState();
}

class _ParkingSpotScreenState extends State<ParkingSpotScreen> {
  bool isFavorite = false;
  bool isFavoriteLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    setState(() {
      isFavoriteLoading = true;
    });
    try {
      // Assumes fetchFavoriteStatus returns a bool
      final status = await fetchFavoriteStatus(widget.lot.id);
      setState(() {
        isFavorite = status;
        isFavoriteLoading = false;
      });
    } catch (e) {
      setState(() {
        isFavorite = widget.lot.isFavorite;
        isFavoriteLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load favorite status: $e')),
        );
      }
    }
  }

  Future<void> _toggleFavorite(BuildContext context) async {
    setState(() {
      isFavoriteLoading = true;
    });
    try {
      final success =
          await toggleFavoriteLot(widget.lot.id, isFavorite: isFavorite);
      if (success) {
        setState(() {
          isFavorite = !isFavorite;
          isFavoriteLoading = false;
        });

        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(isFavorite
                  ? 'Added to favorites'
                  : 'Removed from favorites')),
        );
      } else {
        setState(() {
          isFavoriteLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isFavoriteLoading = false;
      });
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update favorite: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? imagePath =
        widget.lot.images.isNotEmpty ? widget.lot.images[0] : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lot.name),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: isFavoriteLoading
                ? null
                : () {
                    _toggleFavorite(context);
                  },
            tooltip: isFavoriteLoading
                ? 'Loading...'
                : (isFavorite ? 'Unfavorite' : 'Favorite'),
          ),
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: 200,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter:
                        LatLng(widget.lot.latitude, widget.lot.longitude),
                    initialZoom: 14.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(markers: [
                      Marker(
                        point:
                            LatLng(widget.lot.latitude, widget.lot.longitude),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          grade: 12,
                          size: 50,
                        ),
                      )
                    ])
                  ],
                ),
              ),
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 214, 245, 250),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                ),
                child: (imagePath != null && imagePath.isNotEmpty)
                    ? Image(
                        image: getLotImageProvider(imagePath),
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/placeholder_image.png',
                            scale: 0.1,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/images/placeholder_image.png',
                        scale: 0.1,
                      ),
              ),
              const SizedBox(height: 24),
              const Text(
                '300 Meters Away',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Text('ETB 25/hr',
                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 14)),
              const SizedBox(height: 24),
              const Text('ABOUT'),
              Column(
                children: [
                  Text(widget.lot.description ??
                      'A spacious parking lot with ample space.')
                ],
              ),
              const SizedBox(height: 24),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 28, 93, 102),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Reserve Spot',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SafeArea(child: Reviews(lot: widget.lot)),
            ],
          )),
    );
  }
}
