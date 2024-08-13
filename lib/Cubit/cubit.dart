import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled2/Cubit/states.dart';

import '../scrrens/Archive_Screen.dart';
import '../scrrens/Done Screen.dart';
import '../scrrens/New_Screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppinitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentindex = 0;

  List<Widget> screens = [
    NewTask(),
    DoneTasks(),
    ArchiveTasks(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archive Tasks',
  ];

  void ChangeIndex(int index) {
    currentindex = index;
    emit(NavBar());
  }

  Database? database;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  void CreateDatabase() {
    openDatabase('TodoTasksFinal.db', version: 1,
        onCreate: (database, version) {
      print('database has been created');
      emit(createDatabase());
      database
          .execute(
              'CREATE TABLE NewTasks (id INTEGER PRIMARY KEY, Title TEXT, Time TEXT, Date TEXT, Status TEXT)')
          .then((value) {
        print('Table created');
      }).catchError((error) {
        print('Error on create database ${error.toString()}');
      });
    }, onOpen: (database) {
      GetDataFromDatabase(database);
      print('database has been opened');
    }).then((value) {
      database = value;
    });
  }

  InsertDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database?.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO NewTasks(Title, Time, Date, Status) VALUES("$title", "$time", "$date", "new")')
          .then((value) {
        print('$value has been inserted');
        emit(insertDatabase());
        GetDataFromDatabase(database);
      }).catchError((error) {
        print('error on insert ${error.toString()}');
      });
    });
  }

  void GetDataFromDatabase(database) {
    emit(getFromDatabase());
    database.rawQuery('SELECT * FROM NewTasks').then((value) {
      // value = Tasks;
      // print(Tasks);
      emit(getFromDatabase());
      value.forEach((element) {
        print(element['Status']);
        if (element['Status'] == 'new') {
          newTasks.add(element);
        } else if (element['Status'] == 'done') {
          doneTasks.add(element);
        } else {
          archiveTasks.add(element);
        }
      });
    });
  }

  IconData FabIcon = Icons.edit;

  bool isButtonShown = false;

  void ChangeButton({required bool show, required IconData icon}) {
    isButtonShown = show;
    FabIcon = icon;
    emit(ButtonShow());
  }

  void UpdateDatabase({required String Status, required int id}) async {
    database?.rawUpdate('UPDATE NewTasks SET Status = ? WHERE id = ?',
        ['$Status', id]).then((value) {
      GetDataFromDatabase(database);
      emit(updateDatabase());
    });
  }

  void DeleteFromDatabase({required int id}) async {
    database
        ?.rawDelete('DELETE FROM NewTasks WHERE id = ?', [id]).then((value) {
      GetDataFromDatabase(database);
    });
  }
}
