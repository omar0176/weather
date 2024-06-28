import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart'; // Package to reuse objects in diferent files
import 'package:url_launcher/url_launcher.dart'; // Package to launch URLs
import 'utils.dart'; // Custom utilities class

final Uri _url = Uri.parse('https://vanishjr.github.io/nimbus-website/index.html');

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key}); // Constructor

  // Instance of the Utils class
  final Utils unit = Utils();

  @override
  Widget build(BuildContext context) {
    // Obtain the Utils instance from the provider
    Utils unit = Provider.of<Utils>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(5.0), // Adds padding
        child: ListView(
          children: [
            // ListTile for changing unit 
            ListTile(
              leading: const Icon(Icons.settings_input_component_outlined), // Icon for the setting
              title: const Text('Units'), // Title of the setting
              subtitle: const Text('Change units of measurement'), // Subtitle/description
              onTap: () {
                // Show a modal bottom sheet when the ListTile is tapped
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    // StatefulBuilder allows the bottom sheet to be stateful
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min, // Minimize the column size
                          children: [
                            // Radio button for selecting Celsius
                            RadioListTile<String>(
                              title: const Text('Celsius'), // Label for the option
                              value: 'Celsius', // Value for this radio option
                              groupValue: unit.isCelsius ? 'Celsius' : 'Fahrenheit', // Current selected value
                              onChanged: (value) {
                                // When the value changes, update the state and the Utils instance
                                setState(() {
                                  unit.setIsCelsius(true);
                                });
                              },
                            ),
                            // Radio button for selecting Fahrenheit
                            RadioListTile<String>(
                              title: const Text('Fahrenheit'), // Label for the option
                              value: 'Fahrenheit', // Value for this radio option
                              groupValue: unit.isCelsius ? 'Celsius' : 'Fahrenheit', // Current selected value
                              onChanged: (value) {
                                // When the value changes, update the state and the Utils instance
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
            // ListTile for opening website
            ListTile(
              leading: const Icon(Icons.public), // Icon for the setting
              title: const Text('Website'), // Title of the setting
              subtitle: const Text('Find out more on the web!'), // Subtitle/description
              onTap: () {
                // Launch URL on tap
                _launchUrl();
              },
            ),
            // Listtile for displaying app version
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

  // launch URL
  Future<void> _launchUrl() async {
    // Exception Handling
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
