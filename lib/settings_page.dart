import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // package to launch URLs

final Uri _url = Uri.parse('https://www.mercedes-benz-berlin.de/passengercars/startpage.html'); // URL to open

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(
            5.0), // adds some padding to bring the content away from the edges
        child: ListView(
          // List of settings
          children: [
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
              subtitle: const Text('Switch between appearance mode'),
              onTap: () {
                // Navigate to help & support
              },
            ),
            ListTile(
              leading: const Icon(Icons.public),
              title: const Text('Website'),
              subtitle: const Text('Find out more on the web!'),
              onTap: () {
                _launchUrl(); // Opens website homepage
              },
            ),
            const ListTile(
              leading: Icon(Icons.info), // displays the version of the app
              title: Text('About'),
              subtitle: Text('Version: 0.0.2'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl() async { //if URL cannot be launched, throws exception
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
