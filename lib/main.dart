import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sqlite_crud/view/pages/todos_page.dart';

void main() async {

  debugPaintSizeEnabled = true;
  runApp(TodosApp());
}

class TodosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodosPage(),
    );
  }
}
