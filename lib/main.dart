import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notify_event/add_event.dart';
import 'package:notify_event/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try{
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
    print('success');
  }catch(e){
    print('failed : $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  AddEventPage(),
    );
  }
}

