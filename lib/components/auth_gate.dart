import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letterboxd/pages/intro_page.dart';
import 'package:letterboxd/pages/main_navigation.dart';
import 'package:letterboxd/store/auth/auth_controller.dart';

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Add a small delay to ensure Firebase is properly initialized
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isInitialized = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final authState = ref.watch(authControllerProvider);

    if (authState == null) {
      return const IntroPage();
    } else {
      return const MainNavigation();
    }
  }
}
