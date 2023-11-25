import 'package:flutter/material.dart';
import 'package:yourbookexperience/list/list_page.dart';
import 'package:yourbookexperience/common/theme/theme.dart';

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
      theme: ThemeBuilder.getThemeData(),
      home: const ListPage(),
    );
  }
}
