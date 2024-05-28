import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool _isDialogVisible = false; // Variable to toggle the dialog box

  void _toggleTextBox() {
    // Function to toggle the dialog box on and off
    setState(() {
      _isDialogVisible = !_isDialogVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        // Gesture Detector to disable searchbar when tapped
        onTap: () {
          if (_isDialogVisible) {
            _toggleTextBox();
          }
        },
        child: Stack(
          // Stack to overlay the Searchbar on the main page
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  // Scrollable widget
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'images/Sunny/Trees.png'), // Background image
                          fit: BoxFit.fitWidth, // Image fit the width
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(
                            16.0), // Padding around the main content
                        child: Column(
                          children: [
                            const SizedBox(height: 20), // spacing
                            OutlinedButton.icon(
                              // Button to toggle the search bar
                              onPressed: _toggleTextBox,
                              icon: const Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  side: const BorderSide(
                                      width: 1, color: Colors.grey)),
                              label: const Text(
                                'My Location',
                                style: TextStyle(
                                    fontSize: 46,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ),
                            const Center(
                              child: Text(
                                '<location_name>',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 20), //spacing
                            Column(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // centering the content
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                    'images/Sunny/SUN.png'), // Image of the sun
                                const SizedBox(height: 10), //spacing
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFB2E4FA)
                                            .withOpacity(0.3),
                                        offset: const Offset(0, 4),
                                        blurRadius: 4,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  margin: const EdgeInsets.all(16),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text('16°',
                                          style: TextStyle(fontSize: 80)),
                                      Text('<weather_conditions>'),
                                      Text('H:<today_high>    L:<today_low>'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              // widget design for the today's weather forecast
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFB2E4FA)
                                        .withOpacity(0.3), //shadow color
                                    offset: const Offset(0, 4), // offset
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                  ),
                                ],
                                color: Colors.white
                                    .withOpacity(0.3), // background color
                                borderRadius:
                                    BorderRadius.circular(20), // border corners
                              ),
                              // hourly forecast widget
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.all(16),
                              child: SingleChildScrollView(
                                //horizontally scrollable widget
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  // row for every hour
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      // column to display time, weather conditions and temperature
                                      children: [
                                        const Center(
                                          child: Text('1pm'),
                                        ),
                                        Image.asset('images/Symbols/cloud.png'),
                                        const Center(
                                          child: Text(
                                            '17°',
                                            style: TextStyle(
                                                // temp style
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                        width: 28), //  horizontal spacing
                                    Column(
                                      children: [
                                        const Center(
                                          child: Text('2pm'),
                                        ),
                                        Image.asset(
                                            'images/Symbols/cloud-drizzle.png'),
                                        const Center(
                                          child: Text(
                                            '15°',
                                            style: TextStyle(
                                                // temp style
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                        width: 28), //  horizontal spacing
                                    Column(
                                      children: [
                                        const Center(
                                          child: Text('3pm'),
                                        ),
                                        Image.asset(
                                            'images/Symbols/cloud-lightning.png'),
                                        const Center(
                                          child: Text(
                                            '13°',
                                            style: TextStyle(
                                                // temp style
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                        width: 28), //  horizontal spacing
                                    Column(
                                      children: [
                                        const Center(
                                          child: Text('4pm'),
                                        ),
                                        Image.asset(
                                            'images/Symbols/cloud-snow.png'),
                                        const Center(
                                          child: Text(
                                            '12°',
                                            style: TextStyle(
                                                // temp style
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                        width: 28), //  horizontal spacing
                                    Column(
                                      children: [
                                        const Center(
                                          child: Text('5pm'),
                                        ),
                                        Image.asset(
                                            'images/Symbols/sun logo.png'),
                                        const Center(
                                          child: Text(
                                            '11°',
                                            style: TextStyle(
                                                // temp style
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                        width: 28), //  horizontal spacing
                                    Column(
                                      children: [
                                        const Center(
                                          child: Text('6pm'),
                                        ),
                                        Image.asset(
                                            'images/Symbols/cloud-lightning.png'),
                                        const Center(
                                          child: Text(
                                            '20°',
                                            style: TextStyle(
                                                // temp style
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              // trees asset display
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('images/Sunny/Trees.png'),
                                  fit: BoxFit.cover, // image fit
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            if (_isDialogVisible) // to display the search bar
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // blur effect
                child: Container(
                  color: Colors.black.withOpacity(0.5), // blur darkening effect
                  child: Center(
                      child: Column(
                    children: [
                      const SizedBox(height: 40), // spacing
                      Container(
                        height: 50,
                        width: 300,
                        decoration: BoxDecoration(
                            // search bar design
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 1.0),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          // search bar text field
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z,\s]'))
                          ], // Restrict to alphabets and whitespaces

                          decoration: const InputDecoration(
                            // Text field design
                            hintText: 'Berlin, Germany',
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 12.0),
                          ),
                        ),
                      )
                    ],
                  )),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
