import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import 'register_view.dart';
import 'home_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Login - Gasolina Fácil')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Replace with IFPI logo asset
            FlutterLogo(size: 100),
            SizedBox(height: 16),
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passCtrl,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: 'Senha',
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final ok = await auth.login(_emailCtrl.text.trim(), _passCtrl.text);
                if (ok) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeView()));
                else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login falhou')));
              },
              child: Text('Entrar'),
            ),
            TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterView())), child: Text('Cadastrar conta')),
            TextButton(onPressed: () async {
              final ok = await auth.recoverPassword(_emailCtrl.text.trim());
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Instruções enviadas (simulado)' : 'Email não cadastrado')));
            }, child: Text('Recuperar senha'))
          ],
        ),
      ),
    );
  }
}