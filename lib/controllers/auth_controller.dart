import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../services/db_service.dart';

class AuthController extends ChangeNotifier {
  final _storage = FlutterSecureStorage();
  User? _user;
  User? get user => _user;

  
  Future<bool> register(String email, String password) async {
    final id = Uuid().v4();
    
    final user = User(id: id, email: email, passwordHash: password);

    final usersBox = DBService().usersBox;
    await usersBox.put(email, user.toMap());

    await _storage.write(key: 'user_email', value: email);

    return true;
  }

  
  Future<bool> login(String email, String password) async {
    final usersBox = DBService().usersBox;
    final data = usersBox.get(email);

    if (data == null) return false;

    final u = User.fromMap(Map<String, dynamic>.from(data));

    if (u.passwordHash == password) {
      _user = u;
      notifyListeners();
      return true;
    }

    return false;
  }

  
  Future<void> logout() async {
    _user = null;
    await _storage.delete(key: 'user_email');
    notifyListeners();
  }

  
  Future<bool> recoverPassword(String email) async {
    final usersBox = DBService().usersBox;
    return usersBox.containsKey(email);
  }
}