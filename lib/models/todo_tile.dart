import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ToDoTile extends StatelessWidget {
  late String taskName;
  late String taskDescription;
  final String taskTag;
  final DateTime creationDate;
  final DateTime? deadlineDate;
  final bool taskCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;
  final Function(BuildContext)? completeFunction;
  final Function(String) onNameChanged;
  ToDoTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
    required this.completeFunction,
    required this.taskDescription,
    required this.taskTag,
    required this.creationDate,
    required this.deadlineDate,
    required this.onNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 5),
      child: Slidable(
          startActionPane: ActionPane(
            motion: StretchMotion(),
            children: [
              SlidableAction(
                onPressed: completeFunction,
                icon: Icons.check,
                backgroundColor: Colors.green.shade300,
                borderRadius: BorderRadius.circular(16),
              )
            ],
          ),
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                onPressed: deleteFunction,
                icon: Icons.delete,
                backgroundColor: Colors.red.shade300,
                borderRadius: BorderRadius.circular(16),
              )
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.withOpacity(0.5),
                width: 1.0,
              ),
            ),
            child: Stack(children: [
              Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.info,
                      color: Colors.green.shade300,
                    ),
                    onPressed: () {
                      TextEditingController taskNameController =
                          TextEditingController(text: taskName);
                      TextEditingController taskDescriptionController =
                          TextEditingController(text: taskDescription);

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                title: Text('Редактировать задачу'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: taskNameController,
                                      decoration: InputDecoration(
                                          labelText: 'Название задачи'),
                                    ),
                                    TextField(
                                      controller: taskDescriptionController,
                                      decoration: InputDecoration(
                                          labelText: 'Описание задачи'),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                        'Дата: ${DateFormat('dd.MM.yyyy').format(creationDate)}')
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Сохранить'),
                                    onPressed: () {
                                      setState(() {
                                        taskName = taskNameController.text;
                                        taskDescription =
                                            taskDescriptionController.text;
                                      });
                                      onNameChanged(taskName);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Отмена'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      //Чекбокс
                      Checkbox(
                        value: taskCompleted,
                        onChanged: onChanged,
                        activeColor: Colors.green.shade300,
                      ),

                      //Название задачи
                      Text(taskName,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              decoration: taskCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none)),
                    ],
                  ),

                  Column(
                    children: [
                      //Тэг
                      RichText(
                          text: TextSpan(text: '    ', children: [
                        if (taskTag != 'Без тега')
                          const WidgetSpan(
                              child: Icon(
                            Icons.sell,
                            size: 15,
                          )),
                        if (taskTag != 'Без тега')
                          TextSpan(
                            text: ' $taskTag',
                            style: TextStyle(color: Colors.grey),
                          ),
                        if (deadlineDate != null)
                          TextSpan(
                              text:
                                  '  ${DateFormat('dd.MM.yyyy HH:mm').format(deadlineDate!)}',
                              style: TextStyle(color: Colors.red.shade300)),
                      ])),
                    ],
                  ),

                  // Text(
                  //   taskDescription,
                  //   style: TextStyle(color: Colors.grey),
                  // ),

                  // Text(
                  //   'Дата создания: ${DateFormat('dd.MM.yyyy').format(creationDate)}',
                  //   style: TextStyle(color: Colors.grey),
                  // ),
                ],
              ),
            ]),
          )),
    );
  }
}
