import 'package:galerix/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const Galerix());

class Galerix extends StatelessWidget {
  const Galerix({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Galerix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Museo Sans',
      ),
      home: const HomeScreen(),
    );
  }
}
