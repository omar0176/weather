import 'package:flutter/material.dart';
import 'package:weather/bookmarks_page.dart';
import 'package:weather/settings_page.dart';
import 'home_page.dart';

// Base UI and navigation structure
class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

int currentPageIndex = 0; // Index of the current page

class _NavigationState extends State<Navigation> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // hides the debug banner
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar( // Top app bar with title
            title: const Center(
              child: Text('Nimbus'), // App title
            ),
            backgroundColor:
            Colors.white.withOpacity(0.5), // Title background color
          ),
          backgroundColor: const Color(0xFFDCE3EA), // Page background color
          bottomNavigationBar: NavigationBar(
            indicatorColor: Colors.green, // NavBar Indicator color
            backgroundColor: Colors.white
                .withOpacity(0.5), // NavBar background color
            onDestinationSelected: (int index) {
              setState(() { // function to update the state of the Widget
                currentPageIndex = index; // Sets the current page index
              });
            },
            destinations: const [ // List of navigation options
              // Navigation destinations
              NavigationDestination(             // Home page
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(             // Bookmarks page
                icon: Icon(Icons.bookmark_border_outlined),
                selectedIcon: Icon(Icons.bookmark),
                label: 'Bookmarks',
              ),
              NavigationDestination(             // Settings page
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            selectedIndex: currentPageIndex, // Selected index
          ),
          body: IndexedStack( //keeps state of other pages while displaying a specific one
            index: currentPageIndex,
            children: [
              const HomePage(),
              const BookmarksPage(),
              SettingsPage(),
            ],
          ),
        ),
      ),
    );
  }
}
