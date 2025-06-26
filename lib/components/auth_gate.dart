import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letterboxd/pages/auth_page/login_page.dart';
import 'package:letterboxd/pages/intro_page.dart';
import 'package:letterboxd/pages/main_navigation.dart';
import 'package:letterboxd/store/auth/auth_controller.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    if (authState == null) {
      return const IntroPage();
    } else    return const MainNavigation();
  
  }
}
