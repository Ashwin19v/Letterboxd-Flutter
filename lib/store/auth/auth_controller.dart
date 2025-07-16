import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letterboxd/store/auth/auth_repository.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, User?>((ref) {
  final repo = AuthRepository();
  return AuthController(repo)..listenToAuth();
});

class AuthController extends StateNotifier<User?> {
  final AuthRepository repo;

  AuthController(this.repo) : super(null);

  void listenToAuth() {
    repo.authState.listen((user) => state = user);
  }

  Future<void> signup(String email, String password, String name) async {
    final newUser = await repo.signup(email, password, name);
    state = newUser;
  }

  Future<void> login(String email, String password) async {
    final loggedInUser = await repo.login(email, password);
    state = loggedInUser;
  }

  void logout() async {
    await repo.logout();
    state = null;
  }
}
