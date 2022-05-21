import 'package:flutter/material.dart';
import 'package:to_do_app/db/db_provider.dart';
import 'package:to_do_app/model/task_model.dart';

import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyToDoApp(),
    );
  }
}
