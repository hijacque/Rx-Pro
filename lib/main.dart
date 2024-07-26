import 'package:flutter/material.dart';

import 'package:rxpro_app/pages/doctor-home-page.dart';
import 'package:rxpro_app/style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: INDIGO),
        useMaterial3: true,
      ),
      home: const DoctorHomePage(),
    );
  }
}