import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/bookmarks_page.dart';
import 'package:weather/settings_page.dart';
import 'home_page.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

int currentPageIndex = 0; // Index of the current page

class _MainWindowState extends State<MainWindow> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text('Aeolus'), // App title
            ),
            backgroundColor:
                Colors.white.withOpacity(0.5), // Title background color
          ),
          backgroundColor: const Color(0xFFDCE3EA), // Page background color
          bottomNavigationBar: NavigationBar(
            indicatorColor: Colors.green, // Indicator color
            backgroundColor: Colors.white
                .withOpacity(0.5), // navigation bar background color
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index; // Sets the current page index
              });
            },
            destinations: const [
              // Navigation destinations
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(CupertinoIcons.bookmark),
                selectedIcon: Icon(Icons.bookmark),
                label: 'Bookmarks',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            selectedIndex: currentPageIndex, // Selected index
          ),
          body: IndexedStack(
            index: currentPageIndex,
            children: const [
              HomePage(),
              BookmarksPage(),
              SettingsPage(),
            ],
          ),
        ),
      ),
    );
  }
}
