import 'package:flavor_harmony_app/pages/welcome_screen.dart/splash_screen.dart';
import 'package:flavor_harmony_app/services/user-information-services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'services/image_picker_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  print("EDAMAM_API_KEY: ${dotenv.env['EDAMAM_API_KEY']}");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Firebase başlatıldı.");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserInformationServices()),
        ChangeNotifierProvider(create: (_) => ImagePickerService()),
      ],
      child: MainApp(),
    ),
  );
}

Future<void> _initializePermissions() async {
  final status = await Permission.activityRecognition.request();
  if (status != PermissionStatus.granted) {
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
