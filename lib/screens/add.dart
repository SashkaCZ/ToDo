import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();
  String _selectedTag = 'Без тега';
  DateTime _creationDate = DateTime.now();
  DateTime? _deadlineDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text('Добавить задачу'),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                Navigator.pushNamed(context, '/taskList');
              })),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          //Задача
          TextField(
            controller: _taskNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Наименование задачи",
            ),
          ),
          //Описание задачи
          const SizedBox(height: 20),
          TextField(
            controller: _taskDescriptionController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Описание задачи",
            ),
          ),
          //Добавление тега
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _selectedTag,
            onChanged: (String? value) {
              if (value != null) {
                _selectedTag = value;
              }
            },
            items: ['Без тега', 'Семья', 'Работа', 'Учеба', 'Покупки']
                .map((tag) => DropdownMenuItem<String>(
                      value: tag,
                      child: Text(tag),
                    ))
                .toList(),
          ),
          //Дата
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(117, 110, 243, 1),
              elevation: 5.0,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: _creationDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_creationDate),
                );
                if (pickedTime != null) {
                  setState(() {
                    _creationDate = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                  });
                }
              }
            },
            child: Text(
              'Дата: ${DateFormat('dd.MM.yyyy').format(_creationDate)} Время: ${DateFormat('HH:mm').format(_creationDate)}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          //Дедлайн
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(117, 110, 243, 1),
              elevation: 5.0,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: _deadlineDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    _deadlineDate = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                  });
                }
              }
            },
            child: Text(
              'Срок выполнения: ${_deadlineDate != null ? DateFormat('dd.MM.yyyy HH:mm').format(_deadlineDate!) : "Не установлен"}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          //Кнопка добавления
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(117, 110, 243, 1),
              elevation: 5.0,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              String newTaskName = _taskNameController.text.trim();
              String newTaskDescription =
                  _taskDescriptionController.text.trim();
              if (newTaskName.isNotEmpty) {
                Navigator.pop(
                  context,
                  {
                    'name': newTaskName,
                    'description': newTaskDescription,
                    'tag': _selectedTag,
                    'creationDate': _creationDate,
                    'deadlineDate': _deadlineDate,
                  },
                );
              }
            },
            child: const Text(
              "Добавить",
              style: TextStyle(color: Colors.white),
            ),
          )
        ]),
      ),
    );
  }
}
