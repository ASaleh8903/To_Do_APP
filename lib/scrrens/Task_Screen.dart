// @dart = 2.7

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/Cubit/cubit.dart';
import 'package:untitled2/Cubit/states.dart';

import '../share/components/components.dart';

class TaskScreen extends StatelessWidget {
  var ScaffoldKey = GlobalKey<ScaffoldState>();

  var formkey = GlobalKey<FormState>();

  var titlecontroller = TextEditingController();

  var timecontroller = TextEditingController();

  var datecontroller = TextEditingController();

  var statuscontroller = TextEditingController();

  var namecontroller = TextEditingController();

  bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AppCubit()..CreateDatabase(),
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            // if (state is insertDatabase) {
            //   Navigator.pop(context);
            // }
          },
          builder: (context, state) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              key: ScaffoldKey,
              appBar: AppBar(
                title: Text(cubit.titles[cubit.currentindex]),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isButtonShown) {
                    cubit.ChangeButton(show: false, icon: Icons.edit);
                    cubit.InsertDatabase(
                        title: titlecontroller.text,
                        date: datecontroller.text,
                        time: timecontroller.text);
                    Navigator.pop(context);
                  } else {
                    cubit.ChangeButton(show: true, icon: Icons.add);
                    ScaffoldKey.currentState
                        .showBottomSheet(
                          (context) => Container(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Form(
                                key: formkey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    defultformfeild(
                                        label: 'Title',
                                        controller: titlecontroller,
                                        type: TextInputType.text,
                                        prefix: Icons.title,
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return 'This field must not be empty';
                                          }
                                          return null;
                                        }),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    defultformfeild(
                                        label: 'Time',
                                        controller: timecontroller,
                                        type: TextInputType.datetime,
                                        prefix: Icons.watch_later_outlined,
                                        onTap: () {
                                          showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then((value) {
                                            timecontroller.text = value
                                                .format(context)
                                                .toString();
                                            print(value.format(context));
                                          });
                                        },
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return 'This field must not be empty';
                                          }
                                          return null;
                                        }),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    defultformfeild(
                                        label: 'Date',
                                        controller: datecontroller,
                                        type: TextInputType.datetime,
                                        prefix: Icons.calendar_month_outlined,
                                        onTap: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime.parse(
                                                      '3000-12-30'))
                                              .then((value) {
                                            datecontroller.text =
                                                DateFormat.yMMMd()
                                                    .format(value);
                                            print(DateFormat.yMMMd()
                                                .format(value));
                                          });
                                        },
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return 'This field must not be empty';
                                          }
                                          return null;
                                        }),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .closed
                        .then((value) {
                      cubit.ChangeButton(show: false, icon: Icons.edit);
                    });
                    cubit.ChangeButton(show: true, icon: Icons.add);
                  }
                },
                child: Icon(cubit.FabIcon),
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.currentindex,
                onTap: (index) {
                  cubit.ChangeIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: 'New Tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline),
                      label: 'Done Tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined),
                      label: 'Archive Tasks'),
                ],
              ),
              body: ConditionalBuilder(
                condition: true,
                builder: (context) => cubit.screens[cubit.currentindex],
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),
              ),
            );
          },
        ));
  }
}
