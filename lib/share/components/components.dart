import 'package:flutter/material.dart';
import 'package:untitled2/Cubit/cubit.dart';

Widget Button({
  double width = double.infinity,
  Color background = Colors.blue,
  required Function function,
  required String text,
}) =>
    Container(
      width: width,
      color: background,
      child: MaterialButton(
        onPressed: () {},
        child: Text(text),
      ),
    );

Widget defultformfeild(
        {double width = double.infinity,
        Color background = Colors.grey,
        required String label,
        required TextEditingController controller,
        required TextInputType type,
        required IconData prefix,
        required Function? validator,
        bool click = true,
        Function? onTap}) =>
    Container(
      width: width,
      child: TextFormField(
          decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(prefix),
              border: OutlineInputBorder()),
          controller: controller,
          enabled: click,
          onTap: () {
            onTap!();
          },
          keyboardType: type,
          validator: (s) {
            validator!(s);
          }),
    );

Widget buildItems(Map modle, context) => Dismissible(
      key: Key(modle['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).DeleteFromDatabase(id: modle['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              backgroundColor: Colors.blue,
              child: Center(
                  child: Text(
                '${modle['Time']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${modle['Title']}',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  SizedBox(
                    width: 40.0,
                  ),
                  Text(
                    '${modle['Date']}',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .UpdateDatabase(Status: 'done', id: modle['id']);
                },
                icon: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .UpdateDatabase(Status: 'archive', id: modle['id']);
                },
                icon: Icon(
                  Icons.archive_outlined,
                  color: Colors.grey,
                )),
          ],
        ),
      ),
    );
