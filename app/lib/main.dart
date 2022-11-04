import 'package:app/pages/HomePage.dart';
import 'package:flutter/material.dart';

void main(context) {
  runApp(
    MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    ),
  );
}
