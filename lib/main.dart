import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/onboarding/splash_screen.dart';
import 'services/auth_service.dart';
import 'firebase_options.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding/welcome_slides.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/preferences_service.dart';
import 'screens/recipe_details_screen.dart';
import 'models/recipe.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  await dotenv.load(fileName: ".env");
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (e.toString().contains('duplicate-app')) {
      debugPrint('Firebase already initialized');
    } else {
      rethrow;
    }
  }

  // Initialize notifications
  final notificationService = NotificationService();
  await notificationService.initializeNotifications();

  // Set up foreground message handler
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      notificationService.showLocalNotification(message);
    }
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthService(),
        ),
        Provider<PreferencesService>(
          create: (_) => PreferencesService(prefs),
        ),
        Provider<NotificationService>(
          create: (_) => notificationService,
        ),
      ],
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'DM Sans',
      ),
      debugShowCheckedModeBanner: true,
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error initializing Firebase'),
            );
          }
          
          if (snapshot.connectionState == ConnectionState.done) {
            return const SplashScreen();
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/signup': (context) => const SignupScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/welcome': (context) => const WelcomeSlides(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/recipe-details') {
          final recipe = settings.arguments as Recipe;
          return MaterialPageRoute(
            builder: (context) => RecipeDetailsScreen(recipe: recipe),
          );
        }
        return null;
      },
    );
  }
}

