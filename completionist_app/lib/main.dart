import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  await prefs.reload();

  final String? savedId = prefs.getString('steamId');

  print("DEBUG: App Started. Found Saved ID: '$savedId'");

  runApp(MyApp(startId: savedId));
}

class MyApp extends StatelessWidget {
  final String? startId;
  const MyApp({super.key, this.startId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Completionist',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: (startId != null && startId!.isNotEmpty)
          ? MainScreen(steamId: startId!)
          : const LoginScreen(),
    );
  }
}
