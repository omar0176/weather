import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isDialogVisible = false;

  void _showTextBox() {
    setState(() {
      _isDialogVisible = true;
    });
  }

  void _hideTextBox() {
    setState(() {
      _isDialogVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
          onTap: () {
              if (_isDialogVisible){
                  _hideTextBox();
              }
          },
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/Sunny/Trees.png'),
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            OutlinedButton.icon(
                              onPressed: _showTextBox,
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
                            const SizedBox(height: 20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset('images/Sunny/SUN.png'),
                                const SizedBox(height: 10),
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
                                    color:
                                        const Color(0xFFB2E4FA).withOpacity(0.3),
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
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        const Center(
                                          child: Text('1pm'),
                                        ),
                                        Image.asset('images/Symbols/cloud.png'),
                                        const Center(
                                          child: Text(
                                            '17°',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
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
                                        Image.asset(
                                            'images/Symbols/cloud-drizzle.png'),
                                        const Center(
                                          child: Text(
                                            '15°',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
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
                                        Image.asset(
                                            'images/Symbols/cloud-lightning.png'),
                                        const Center(
                                          child: Text(
                                            '13°',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
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
                                        Image.asset(
                                            'images/Symbols/cloud-snow.png'),
                                        const Center(
                                          child: Text(
                                            '12°',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
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
                                        Image.asset(
                                            'images/Symbols/sun logo.png'),
                                        const Center(
                                          child: Text(
                                            '11°',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
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
                                        Image.asset(
                                            'images/Symbols/cloud-lightning.png'),
                                        const Center(
                                          child: Text(
                                            '20°',
                                            style: TextStyle(
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
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('images/Sunny/Trees.png'),
                                  fit: BoxFit.cover,
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
            if (_isDialogVisible)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                      child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        height: 50,
                        width: 300,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 1.0),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z,\s]'))], // Restrict to alphabets and whitespaces

                          decoration: const InputDecoration(
                              hintText: 'Berlin, Germany',
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 12.0,horizontal: 12.0),

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
