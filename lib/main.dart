import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book/auth_page.dart';
import 'package:e_book/controller/api_controller.dart';
import 'package:e_book/providers/auth_provider.dart';
import 'package:e_book/providers/downloads_provider.dart';
import 'package:e_book/providers/firebase_provider.dart';
import 'package:e_book/providers/navigation_provider.dart';
import 'package:e_book/views/books_screen.dart';
import 'package:e_book/views/downloads_screen.dart';
import 'package:e_book/views/home_screen.dart';
import 'package:e_book/views/main_screen.dart';
import 'package:e_book/views/saved_books_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    prefs: prefs,
  ));
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(firebaseAuth: FirebaseAuth.instance, prefs: prefs),
        ),
        ChangeNotifierProvider<ApiController>(
          create: (_) => ApiController(),
        ),
        ChangeNotifierProvider<DownloadsProvider>(create: (_) => DownloadsProvider(prefs: prefs)),
        ChangeNotifierProvider(
          create: (_) => SavedBooksProvider(firebaseFirestore: FirebaseFirestore.instance, prefs: prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => NavigationProvider(),
        )
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: HomeScreen.routeName,
        routes: {
          HomeScreen.routeName: (context) => StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    return const MainScreen();
                  } else {
                    return const AuthPage();
                  }
                },
              ),
          SavedBooksScreen.routeName: (context) => const SavedBooksScreen(),
          DownloadsScreen.routeName: (context) => const DownloadsScreen()
        },
      ),
    );
  }
}
