import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tododo/data/database.dart';
import 'package:tododo/models/todo_tile.dart';
import 'package:tododo/screens/add.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _searchTaskController = TextEditingController();
  bool _isCalendarVisible = false;
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();
  List<List<dynamic>> activeTasks = [];
  List<List<dynamic>> completedTasks = [];
  String currentTagFilter = '';
  DateTime selectedDate = DateTime.now();
  List<String> tags = ['Все'];

  @override
  void initState() {
    db.loadData();
    super.initState();
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateData();
  }

  void _addTask(String taskName, String taskDescription, String tag,
      DateTime creationDate, DateTime? deadlineDate) {
    setState(() {
      db.toDoList.add(
          [taskName, false, taskDescription, tag, creationDate, deadlineDate]);
    });
    db.updateData();
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateData();
  }

  void completeTask(int index) {
    setState(() {
      db.toDoList[index][1] = true;
    });
    db.updateData();
  }

  Future<void> _navigateToAddTaskScreen() async {
    Map<String, dynamic>? newTask = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );
    if (newTask != null) {
      _addTask(
        newTask['name'],
        newTask['description'],
        newTask['tag'],
        newTask['creationDate'],
        newTask['deadlineDate'],
      );
    }
  }

  List<dynamic> filterTasks(String searchText) {
    String searchLowerCase = searchText.toLowerCase();

    return db.toDoList.where((task) {
      String taskName = task[0].toLowerCase();
      return taskName.contains(searchLowerCase);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    int count = db.toDoList.where((task) => !task[1]).length;

    List<dynamic> completedTasks =
        db.toDoList.where((task) => task[1]).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Мои задачи"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _navigateToAddTaskScreen,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(right: 24, left: 24),
            child: TextField(
              controller: _searchTaskController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Color.fromARGB(1, 117, 110, 243))),
                  prefixIcon: Icon(Icons.search),
                  labelText: "Что надо сделать?",
                  labelStyle: TextStyle(color: Colors.grey)),
              onChanged: (text) {
                setState(() {});
              },
            ),
          ),
          // Основная область с текущей датой и количеством невыполненных задач
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat.MMMMd('ru_RU')
                          .format(DateTime.now())
                          .toLowerCase(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_month),
                      onPressed: () {
                        setState(() {
                          _isCalendarVisible = !_isCalendarVisible;
                        });
                      },
                    ),
                  ],
                ),
                Text(
                  '$count ${count == 1 || count % 10 == 1 && count % 100 != 11 ? 'задача' : count % 10 == 2 && count % 100 != 12 || count % 10 == 3 && count % 100 != 13 || count % 10 == 4 && count % 100 != 14 ? 'задачи' : 'задач'} на сегодня',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          // Горизонтально прокручиваемый календарь с датами
          Visibility(
            visible: _isCalendarVisible,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.only(left: 24),
                  height: 140.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 14,
                    itemBuilder: (context, index) {
                      final date = DateTime.now().add(Duration(days: index));
                      return Container(
                        width: 69.0,
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(117, 110, 243, 1),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat.d().format(date),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat.E('ru_RU')
                                    .format(date)
                                    .toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          // Список задач
          Expanded(
            child: ListView.builder(
              itemCount: filterTasks(_searchTaskController.text).length,
              itemBuilder: (context, index) {
                return ToDoTile(
                    taskName: filterTasks(_searchTaskController.text)[index][0],
                    taskCompleted:
                        filterTasks(_searchTaskController.text)[index][1],
                    taskDescription:
                        filterTasks(_searchTaskController.text)[index][2],
                    taskTag: filterTasks(_searchTaskController.text)[index][3],
                    creationDate: filterTasks(_searchTaskController.text)[index]
                        [4],
                    deadlineDate: filterTasks(_searchTaskController.text)[index]
                        [5],
                    onChanged: (value) => checkBoxChanged(value, index),
                    deleteFunction: (context) => deleteTask(index),
                    completeFunction: (context) => completeTask(index),
                    onNameChanged: (newName) {
                      setState(() {
                        filterTasks(_searchTaskController.text)[index][0] =
                            newName;
                      });
                    });
              },
            ),
          ),
          // Список завершенных задач
          if (completedTasks.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Завершенные',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: completedTasks.length,
                itemBuilder: (context, index) {
                  return ToDoTile(
                      taskName: completedTasks[index][0],
                      taskCompleted: completedTasks[index][1],
                      taskDescription: completedTasks[index][2],
                      taskTag: completedTasks[index][3],
                      creationDate: completedTasks[index][4],
                      deadlineDate: completedTasks[index][5],
                      onChanged: (value) => checkBoxChanged(value, index),
                      deleteFunction: (context) => deleteTask(index),
                      completeFunction: (context) => completeTask(index),
                      onNameChanged: (newName) {
                        setState(() {
                          filterTasks(_searchTaskController.text)[index][0] =
                              newName;
                        });
                      });
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
