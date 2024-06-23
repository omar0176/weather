import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // to help reuse objects across the app
import 'package:url_launcher/url_launcher.dart'; // package to launch URLs
import 'utils.dart'; // Utils class

final Uri _url = Uri.parse('https://www.mercedes-benz-berlin.de/passengercars/startpage.html'); // URL to open

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});
  final Utils unit = Utils(); // Instance of the Utils class

  @override
  Widget build(BuildContext context) {
    Utils unit = Provider.of<Utils>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(
            5.0), // adds some padding to bring the content away from the edges
        child: ListView(
          // List of settings
          children: [
            ListTile(
              leading: const Icon(Icons.settings_input_component_outlined), //change it to whatever icon you want
              title: const Text('Units'),
              subtitle: const Text('Change units of measurement'),
              onTap: () {
                showModalBottomSheet(context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RadioListTile<String>(
                              title: const Text('Celsius'),
                              value: 'Celsius',
                              groupValue: unit.isCelsius? 'Celsius' : 'Fahrenheit',
                              onChanged: (value) {
                                setState(() {
                                  unit.setIsCelsius(true);
                                });
                              },
                            ),RadioListTile<String>(
                              title: const Text('Fahrenheit'),
                              value: 'Fahrenheit',
                              groupValue: unit.isCelsius? 'Celsius' : 'Fahrenheit',
                              onChanged: (value) {
                                setState(() {
                                  unit.setIsCelsius(false);
                                });
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
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