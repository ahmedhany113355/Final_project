import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart'; // ��� �� UserModel ���� �������

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? _currentUser;
  bool _isLoggedIn = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _currentUser = null;
      _isLoggedIn = false;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
    } else {
      await _loadUserData(firebaseUser.uid);
      _isLoggedIn = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
    }
    notifyListeners();
  }

  Future<void> _loadUserData(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        _currentUser = UserModel.fromDocument(userDoc);
      } else {
        _currentUser = null;
      }
    } catch (e) {
      debugPrint(
          '��� �� ����� ������ ��������: $e');
      _currentUser = null;
    }
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _loadUserData(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('�� ���� ������ ���� ������ ����������.');
      } else if (e.code == 'wrong-password') {
        throw Exception('���� ������ �����.');
      }
      throw Exception('��� ����� ������: ${e.message}');
    } catch (e) {
      throw Exception('��� ��� ��� �����: ${e.toString()}');
    }
  }

  Future<void> signUp(
    String email,
    String password,
    String firstName,
    String lastName,
    String phone,
    String address,
    String gender,
    DateTime birthdate,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        UserModel newUser = UserModel(
          uid: user.uid,
          email: email,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          address: address,
          gender: gender,
          birthdate: birthdate,
          profileImageUrl: null,
        );
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
        _currentUser = newUser;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('���� ������ ����� ����.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('��� ������ ���������� ���� ������.');
      }
      throw Exception('��� �������: ${e.message}');
    } catch (e) {
      throw Exception('��� ��� ��� �����: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _currentUser = null;
      _isLoggedIn = false;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      notifyListeners();
    } catch (e) {
      throw Exception('��� ����� ������: ${e.toString()}');
    }
  }

  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (_isLoggedIn && _auth.currentUser != null) {
      await _loadUserData(_auth.currentUser!.uid);
    }
    notifyListeners();
    return _isLoggedIn;
  }
}
