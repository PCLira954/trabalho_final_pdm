// lib/services/db_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../models/contact_hive.dart'; // ajuste o caminho

class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;
  DBService._internal();

  Future<void> init() async {
    // Inicializa o Hive no Flutter (gera pastas em armazenamento do app)
    await Hive.initFlutter();

    // Registra o Adapter gerado pelo build_runner
    Hive.registerAdapter(ContactHiveAdapter());

    // Abre as boxes (caixas) que usaremos
    await Hive.openBox<ContactHive>('contacts'); // caixa tipada
    await Hive.openBox('users'); // caixa não tipada para dados simples
  }

  Box<ContactHive> get contactsBox => Hive.box<ContactHive>('contacts');
  Box get usersBox => Hive.box('users');
}
