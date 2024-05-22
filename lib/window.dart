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
          backgroundColor: const Color(0xFFDCE3EA), // Set background color here
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
            const SizedBox(height: 20),
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
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('16°', style: TextStyle(fontSize: 80)),
                      Text('<weather_conditions>'),
                      Text('H:<today_high>    L:<today_low>'),
                    ],
                  ),
                ),
              ],
            ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Center(
                          child: Text('1pm'),
                        ),
                        Image.asset('images/cloud.png'),
                        const Center(
                          child: Text(
                            '17°',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(width: 28),
                    Column(
                      children: [
                        const Center(
                          child: Text('2pm'),
                        ),
                        Image.asset('images/cloud.png'),
                        const Center(
                          child: Text(
                            '15°',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(width: 28),
                    Column(
                      children: [
                        const Center(
                          child: Text('3pm'),
                        ),
                        Image.asset('images/cloud.png'),
                        const Center(
                          child: Text(
                            '13°',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(width: 28),
                    Column(
                      children: [
                        const Center(
                          child: Text('4pm'),
                        ),
                        Image.asset('images/cloud.png'),
                        const Center(
                          child: Text(
                            '12°',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(width: 28),
                    Column(
                      children: [
                        const Center(
                          child: Text('5pm'),
                        ),
                        Image.asset('images/cloud.png'),
                        const Center(
                          child: Text(
                            '11°',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(width: 28),
                    Column(
                      children: [
                        const Center(
                          child: Text('6pm'),
                        ),
                        Image.asset('images/cloud.png'),
                        const Center(
                          child: Text(
                            '20°',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),),
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/Trees.png'), // Path to your image asset
              fit: BoxFit.cover, // Adjust this according to your needs
            ),
          ),
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

  }
}
