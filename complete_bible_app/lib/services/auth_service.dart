import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  Stream<User?> get userChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> login(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> register(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() => _auth.signOut();

  Future<void> resetPassword(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> reauthenticateWithPassword(String password) {
    final user = _auth.currentUser;
    final email = user?.email;
    if (user == null || email == null) {
      throw StateError('Nenhum usuário autenticado.');
    }
    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    return user.reauthenticateWithCredential(credential);
  }

  Future<void> deleteAccount() {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('Nenhum usuário autenticado.');
    }
    return user.delete();
  }
}
