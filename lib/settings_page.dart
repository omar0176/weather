import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('https://www.mercedes-benz-berlin.de/passengercars/startpage.html'); // URL to open

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(5.0), // Border padding 5.0 or 16.0
        child: ListView(
          // List of settings
          children: [
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              subtitle: const Text('Notification preferences'),
              onTap: () {
                // Navigate to notification settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.storage_outlined),
              title: const Text('Storage & Data'),
              subtitle: const Text('Privacy settings and security options'),
              onTap: () {
                // Navigate to privacy & security settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              subtitle: const Text('Change language preferences'),
              onTap: () {
                // Navigate to language settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.light_mode_outlined),
              title: const Text('Theme'),
              subtitle: const Text('Get help and support'),
              onTap: () {
                // Navigate to help & support
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Website'),
              subtitle: const Text('Find out more on the web!'),
              onTap: () {
                // Open website homepage
              _launchUrl();
              },
            ),
            const ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              subtitle: Text('Version: 0.0.2'),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}


