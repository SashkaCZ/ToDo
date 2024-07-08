import 'package:tododo/screens/add.dart';
import 'package:get/get.dart';
import 'package:tododo/screens/login_screen.dart';
import 'package:tododo/screens/registration_screen.dart';
import 'package:tododo/screens/splash_screen.dart';
import 'package:tododo/screens/task_list_screen.dart';


class AppRoutes {
  static final router = [
    GetPage(name: '/', page: () => SplashScreen()),
    GetPage(name: '/login', page: () => LoginScreen()),
    GetPage(name: '/taskList', page: () => TaskListScreen()),
    GetPage(name: '/addTask', page: () => AddTaskScreen()),
    GetPage(name: '/register', page: () => RegisterScreen()),
  ];
}




// final router = {
  
//   '/': (context) => SplashScreen(),
//   '/login': (context) =>  LoginScreen(),
//   '/taskList': (context) =>  TaskListScreen(),
//   '/addTask':(context) => AddTaskScreen(),
//   '/register': (context) => RegisterScreen()
// };