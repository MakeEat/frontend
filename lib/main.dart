import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/auth/login_screen.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  debugPrint('=== FIREBASE INITIALIZATION START ===');
  try {
    final firebaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase App Name: ${firebaseApp.name}');
    debugPrint('Firebase Project ID: ${firebaseApp.options.projectId}');
    debugPrint('Firebase API Key: ${firebaseApp.options.apiKey.substring(0, 5)}...');
    
    // Verify Auth instance
    final auth = FirebaseAuth.instance;
    debugPrint('Firebase Auth Instance Created: ${auth.app.name}');
    
  } catch (e) {
    debugPrint('!!! FIREBASE INITIALIZATION ERROR !!!');
    debugPrint(e.toString());
    return; // Stop app if Firebase fails to initialize
  }

  await dotenv.load(fileName: ".env");
  debugPrint('=== APP INITIALIZATION COMPLETE ===');
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MakeEat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginScreen(key: Key('login')),
      routes: {
        '/login': (context) => const LoginScreen(key: Key('login')),
        // Add other routes as needed
      },
    );
  }
}
