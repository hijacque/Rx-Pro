import 'package:flutter/material.dart';

import 'package:rxpro_app/pages/new-prescription-page.dart';
import 'package:rxpro_app/pages/doctor-home-page.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/doctor': (context) => const DoctorHomePage(),
        '/rx': (context) => const PrescriptionPage(),
      },
      initialRoute: '/doctor',
    );
  }
}