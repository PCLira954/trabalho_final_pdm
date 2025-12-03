import 'package:flutter/material.dart';
import 'contacts_view.dart';
import 'map_view.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gasolina Fácil - Home')),
      body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ContactsView())), child: Text('Postos de Gasolina')),
        ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MapView())), child: Text('Mapas')),
      ])),
    );
  }
}