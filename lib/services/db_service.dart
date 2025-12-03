import 'package:hive_flutter/hive_flutter.dart';
import '../models/contact_hive.dart'; 

class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;
  DBService._internal();

  Future<void> init() async {
    
    await Hive.initFlutter();

    
    Hive.registerAdapter(ContactHiveAdapter());

    
    await Hive.openBox<ContactHive>('contacts'); 
    await Hive.openBox('users'); 
  }

  Box<ContactHive> get contactsBox => Hive.box<ContactHive>('contacts');
  Box get usersBox => Hive.box('users');
}
