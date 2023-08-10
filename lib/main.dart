import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/charge_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cobraticket PDA',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0f042e),
      ),
      home: const CashlessChargePage(),
    );
  }
}
