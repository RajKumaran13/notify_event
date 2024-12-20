import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notify_event/add_event.dart';
import 'package:notify_event/firebase_options.dart';
import 'package:notify_event/notification_service.dart';
import 'package:timezone/data/latest.dart' as tzData;
import 'package:timezone/data/latest_all.dart' as tz;


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
  try{
    await NotificationService.initialize();
    
    print('notify success');
  }catch(e){
    print('notify failed: $e');
  }
   tz.initializeTimeZones();
  
  tzData.initializeTimeZones();
  
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

