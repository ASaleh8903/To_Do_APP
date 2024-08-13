import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/scrrens/Task_Screen.dart';

import 'Cubit/Bloc Observer.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const Todo());
}

class Todo extends StatelessWidget {
  const Todo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: TaskScreen(),
      ),
    );
  }
}
