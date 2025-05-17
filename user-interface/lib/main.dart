import 'package:flavor_harmony_app/welcome_screen.dart/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Eğer bu dosya yoksa eklemeniz gerekebilir
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _initializePermissions();
  runApp(MainApp());
}

Future<void> _initializePermissions() async {
  final status = await Permission.activityRecognition.request();
  if (status != PermissionStatus.granted) {
    // İzin verilmedi ise, kullanıcıya bilgi verin
    // Örneğin: Bir diyaloğ gösterin ve uygulamanın düzgün çalışması için izin gerekli olduğunu bildirin
    print('Activity recognition permission not granted.');
  }
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
