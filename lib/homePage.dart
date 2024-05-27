import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
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
                      const Center(
                        child: Text(
                          'My Location',
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.w500),
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
                              color: const Color(0xFFB2E4FA).withOpacity(0.3),
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
                                  Image.asset('images/Symbols/cloud-snow.png'),
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
                                  Image.asset('images/Symbols/sun logo.png'),
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
    );
  }
}
