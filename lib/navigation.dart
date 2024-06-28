import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:weather/bookmarks_page.dart'; 
import 'package:weather/settings_page.dart'; 

class Navigation extends StatefulWidget {
  const Navigation({super.key}); // Constructor

  @override
  State<Navigation> createState() => _NavigationState(); 
}

// Index of the current page
int currentPageIndex = 0;

class _NavigationState extends State<Navigation> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            // Top app bar with title
            title: const Center(
              child: Text(
                'Nimbus', 
                style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'JosefinSlab-Bold',
                ),
              ),
            ),
            backgroundColor: Colors.white.withOpacity(0.5), 
          ),
          backgroundColor: const Color(0xFFDCE3EA), // Page background color
          bottomNavigationBar: NavigationBar(
            indicatorColor: Colors.grey, // indicator color
            backgroundColor: Colors.white.withOpacity(0.5), // NavBar background 
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index; // Sets the current page index
              });
            },
            destinations: const [
              // List of options
              NavigationDestination(
                // Home page
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                // Bookmarks page
                icon: Icon(Icons.bookmark_border_outlined),
                selectedIcon: Icon(Icons.bookmark),
                label: 'Bookmarks',
              ),
              NavigationDestination(
                // Settings page
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            selectedIndex: currentPageIndex, // Selected index
          ),
          body: IndexedStack(
            // Keeps the state of other pages while displaying a specific one
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
