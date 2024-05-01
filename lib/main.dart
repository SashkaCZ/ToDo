import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:tododo/router.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:google_fonts/google_fonts.dart';


void main() async{

  await Hive.initFlutter();
  await Hive.openBox('mybox');
  await Hive.openBox("login");
  await Hive.openBox("accounts");


  initializeDateFormatting('ru_RU', null).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: router,
      theme: ThemeData(
        
        textTheme:
         GoogleFonts.poppinsTextTheme() 
        
        ),
    );
  }
}