import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'package:campuslife_assistant/screens/splash_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBY_jh-LxEEGBnwnviS3uKGuzPm4gIihcI",
          authDomain: "campus-life-assistant-ap-35138.firebaseapp.com",
          projectId: "campus-life-assistant-ap-35138",
          storageBucket: "campus-life-assistant-ap-35138.firebasestorage.app",
          messagingSenderId: "1026680055962",
          appId: "1:1026680055962:web:cce1bbf338476cbe04d723",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirestoreService>(
          create: (_) => FirestoreService(),
        ),
        StreamProvider<User?>.value(
          value: AuthService().authStateChanges, // This will listen to changes in the authentication state
          initialData: null,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Campus Life Assistant',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: SplashScreen(),  // Ensure this screen is implemented correctly
      ),
    );
  }
}

class FirestoreService {
}