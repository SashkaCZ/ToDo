import 'package:tododo/screens/add.dart';

import 'package:tododo/screens/login_screen.dart';
import 'package:tododo/screens/registration_screen.dart';
import 'package:tododo/screens/splash_screen.dart';
import 'package:tododo/screens/task_list_screen.dart';



final router = {
  '/': (context) => SplashScreen(),
  '/login': (context) =>  LoginScreen(),
  '/taskList': (context) =>  TaskListScreen(),
  '/addTask':(context) => AddTaskScreen(),
  '/register': (context) => RegisterScreen()
};