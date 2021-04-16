import 'package:flutter/material.dart';

import 'layouts/home_layouts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Jannah',

        primarySwatch: Colors.blue,
      ),
      home: HomeLayout(),
    );
  }
}

