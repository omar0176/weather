import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.indigo[900],
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Text('Main Page'),
        ),
        body: SafeArea(
            child: ListView(
              padding: EdgeInsets.all(8),
              children: <Widget>[
                Container(
                  height: 50,
                  color: Colors.yellow[500],
                  child: const Center(
                    child: Text('Cont 1'),
                  ),
                ),
                Container(
                  height: 50,
                  color: Colors.purple,
                  child: const Center(
                    child: Text('Cont 2'),
                  ),
                ),
                Container(
                  height: 50,
                  color: Colors.green,
                  child: const Center(
                    child: Text('Cont 3'),
                  ),
                ),
                Container(
                  height: 50,
                  color: Colors.greenAccent,
                  child: const Center(
                    child: Text('Cont 4'),
                  ),
                ),
                Container(
                  height: 50,
                  color: Colors.pink,
                  child: const Center(
                    child: Text('Cont 5'),
                  ),
                )
              ],
            ),
        ),
      ),
    );
  }
}

/*
Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const Icon(
                  Icons.sunny,
                ),
                Container(
                  height: 1,
                  width: 35,
                  color: Colors.black,
                ),
                Container(
                  child: const Text(
                    '23°F',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            Container(),
            Container(),
            Container()
          ],
        ),


 */
