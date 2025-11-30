import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _email = TextEditingController();
  final _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: 'Email')),
          TextField(controller: _pass, obscureText: true, decoration: InputDecoration(labelText: 'Senha')),
          SizedBox(height: 12),
          ElevatedButton(onPressed: () async {
            await auth.register(_email.text.trim(), _pass.text);
            Navigator.pop(context);
          }, child: Text('Registrar'))
        ]),
      ),
    );
  }
}