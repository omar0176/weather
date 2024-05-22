import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Main_window extends StatefulWidget {
  const Main_window({super.key});

  @override
  State<Main_window> createState() => _MainWindowState();
}

int currentPageIndex = 0;

class _MainWindowState extends State<Main_window> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.lightBlue[100], // Set background color here
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: '',
              ),
              NavigationDestination(
                icon: Icon(CupertinoIcons.bookmark),
                selectedIcon: Icon(Icons.bookmark),
                label: '',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: '',
              ),
            ],
            selectedIndex: currentPageIndex,
          ),
          body: IndexedStack(
            index: currentPageIndex,
            children: [
              _buildHomePage(),
              _buildSimplePage('Bookmarks page'),
              _buildSimplePage('Settings page'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Center(
              child: Text(
                'My Location',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
              ),
            ),
            const Center(
              child: Text(
                '<location_name>',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('images/SUN.png'),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFB2E4FA).withOpacity(0.15), 
                        offset: Offset(0, 4), 
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text('16°', style: TextStyle(fontSize: 80)),
                      Text('<weather_conditions>'),
                      Text('H:<today_high>    L:<today_low>'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimplePage(String title) {
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(5.0),
      child: SizedBox.expand(
        child: Center(
          child: Text(title),
        ),
      ),
    );
  }
}
