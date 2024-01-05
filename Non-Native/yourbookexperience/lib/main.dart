import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yourbookexperience/domain/review_bloc.dart';
import 'package:yourbookexperience/list/list_page.dart';
import 'package:yourbookexperience/common/theme/theme.dart';
import 'package:yourbookexperience/repo/repo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Repo _repo = Repo();

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => _repo,
      child: BlocProvider(
          create: (context) => ReviewBloc(_repo)..add(InitRepoEvent()),
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeBuilder.getThemeData(),
            home: const ListPage(),
          )),
    );
  }
}
