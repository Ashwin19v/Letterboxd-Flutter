import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letterboxd/components/auth_gate.dart';
import 'package:letterboxd/pages/add_review_page.dart';
import 'package:letterboxd/pages/auth_page/login_page.dart';
import 'package:letterboxd/pages/auth_page/register_page.dart';
import 'package:letterboxd/pages/intro_page.dart';
import 'package:letterboxd/pages/list_display_page.dart';
import 'package:letterboxd/pages/list_page.dart';
import 'package:letterboxd/pages/main_navigation.dart';
import 'package:letterboxd/pages/movie_info_page.dart';
import 'package:letterboxd/pages/profile_page.dart';
import 'package:letterboxd/pages/recent_watch_page.dart';
import 'package:letterboxd/pages/review_page.dart';
import 'package:letterboxd/pages/watchlist_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Letterboxd',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFBB86FC), // purple accent
          secondary: Color(0xFF03DAC6), // teal for contrast
          onPrimary: Colors.black, // for buttons/text on primary
          surface: Color(0xFF1F1F1F), // card backgrounds
          onSurface: Colors.white, // text on surfaces
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1F1F1F),
          selectedItemColor: Color.fromARGB(255, 166, 110, 251),
          unselectedItemColor: Colors.white54,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Color(0xFF1E1E1E),
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: Colors.white,
          textColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      routes: {
        '/intro': (_) => const IntroPage(),
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/home': (_) => const MainNavigation(),
        '/list': (_) => const ListPage(),
        '/watchlist': (_) => const WatchlistPage(),
        '/recent': (_) => const RecentWatchPage(),
        '/profile': (_) => const ProfilePage(),
        // '/movie_info': (_) => const MovieInfoPage(),
        // '/add_review': (_) => const AddReviewPage(),
        // '/view_review_detail': (_) => const ReviewPage(),
        // '/list_display': (_) => const ListDisplayPage(),
      },
    );
  }
}
