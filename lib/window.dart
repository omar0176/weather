import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Main_window extends StatefulWidget {
  const Main_window({super.key});

  @override
  State<Main_window> createState() => _Main_windowState();
}

int currentPageIndex = 0;

class _Main_windowState extends State<Main_window> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
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
                  label: ''),
              NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: ''),
            ],
            selectedIndex: currentPageIndex,
          ),
          body: <Widget>[
            /// Home page
            Card(
                shadowColor: Colors.transparent,
                child: Column(
                  children: [
                    Container(
                      child: const SizedBox(
                        height: 50,
                      ),
                    ),
                    Container(
                      child: const Center(
                        child: Text(
                          'My Location',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: const Center(
                        child: Text(
                          '<location_name>',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      child: const Center(
                        child: Text(
                          '16°',
                          style: TextStyle(fontSize: 80),
                        ),
                      ),
                    ),
                    Container(
                      child: const Center(
                        child: Text('<weather_conditions>'),
                      ),
                    ),
                    Container(
                      child: const Center(
                        child: Text('H:<today_high>    L:<today_low>'),
                      ),
                    )
                  ],
                ))

            /// Bookmarks page
            ,
            const Card(
              shadowColor: Colors.transparent,
              margin: EdgeInsets.all(5.0),
              child: SizedBox.expand(
                child: Center(
                  child: Text(
                    'Bookmarks page',
                  ),
                ),
              ),
            )

            /// Settings page
            ,
            const Card(
              shadowColor: Colors.transparent,
              margin: EdgeInsets.all(5.0),
              child: SizedBox.expand(
                child: Center(
                  child: Text(
                    'Settings page',
                  ),
                ),
              ),
            )
          ][currentPageIndex],
        ),
      ),
    );
  }
}
