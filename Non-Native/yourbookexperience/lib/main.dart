import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yourbookexperience/domain/review_bloc.dart';
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
    WidgetsFlutterBinding.ensureInitialized();

    return BlocProvider(
        create: (context) => ReviewBloc(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeBuilder.getThemeData(),
          home: const ListPage(),
        ));
  }
}
