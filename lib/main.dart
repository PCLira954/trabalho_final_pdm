import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'controllers/contact_controller.dart';
import 'views/login_view.dart';
import 'services/db_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBService().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => ContactController()),
      ],
      child: MaterialApp(
        title: 'IFPI Contacts',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: LoginView(),
      ),
    );
  }
}