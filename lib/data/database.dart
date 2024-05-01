import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List toDoList = [];

  final _myBox = Hive.box('mybox');

  get completedTasks => null;

  

  void loadData() {
   final loadedData = _myBox.get("TODOLIST");
  toDoList = loadedData != null ? List.from(loadedData) : [];
  }

  void updateData() {
    _myBox.put("TODOLIST", toDoList);
  }
}
