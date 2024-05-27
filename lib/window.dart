import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/bookmarksPage.dart';
import 'package:weather/settingsPage.dart';
import 'homePage.dart';

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
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text('Aeolus'),
            ),
            backgroundColor: Colors.white.withOpacity(0.5),
          ),
          backgroundColor: const Color(0xFFDCE3EA), // Set background color here
          bottomNavigationBar: NavigationBar(
            indicatorColor: Colors.green,
            backgroundColor: Colors.white.withOpacity(0.5),
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            destinations: const [
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
            selectedIndex: currentPageIndex,
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
