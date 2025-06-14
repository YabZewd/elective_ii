import 'package:flutter/material.dart';
import 'package:mobile/screens/favorites.dart';
import 'package:mobile/screens/feedback.dart';
import 'package:mobile/screens/history.dart';
import 'package:mobile/screens/reservations.dart';
import 'package:mobile/screens/settings.dart';
import 'package:share_plus/share_plus.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
  final String _defaultNumber = '+251912345678';
  final String _defaultEmail = 'hilina@nova.com';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 56,
      shadowColor: const Color.fromARGB(38, 8, 28, 31),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: Image.asset(
              'assets/icons/nova.png',
            ),
            currentAccountPictureSize: const Size(295, 68),
            accountEmail: Text(_defaultEmail),
            accountName: Text(_defaultNumber),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 23, 98, 102),
                  Color.fromARGB(255, 35, 116, 128),
                  Color.fromARGB(255, 42, 139, 153),
                  Color.fromARGB(255, 56, 186, 204),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text('My Reservations'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const ReservationsScreen(),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text('Favorites'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const FavoritesScreen(),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('History'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const HistoryScreen(),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share App'),
                  onTap: () async {
                    final params = ShareParams(
                      text:
                          'Share Nova Parking Mobile App\n\nCheckout the Github:\nhttps://github.com/Nova-Automated-Parking/mobile',
                    );

                    final result = await SharePlus.instance.share(params);

                    if (!context.mounted) {
                      return;
                    }

                    if (result.status == ShareResultStatus.success) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Thank you for sharing Nova!')));
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.phone_android),
                  title: const Text('App Feedback'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => FeedbackScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => const SettingsScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
