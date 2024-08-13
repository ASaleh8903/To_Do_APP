import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled2/Cubit/cubit.dart';
import 'package:untitled2/Cubit/states.dart';

import '../share/components/components.dart';

class NewTask extends StatelessWidget {
  const NewTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, states) {},
        builder: (context, states) {
          var Tasks = AppCubit.get(context).newTasks;
          return ListView.separated(
            itemBuilder: (context, index) => buildItems(Tasks[index], context),
            separatorBuilder: (context, index) => Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey,
            ),
            itemCount: Tasks.length,
          );
        });
  }
}
