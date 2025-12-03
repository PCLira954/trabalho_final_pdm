import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/contact_controller.dart';
import '../models/contact.dart';
import 'contact_form.dart';

class ContactsView extends StatefulWidget {
  @override
  _ContactsViewState createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  @override
  void initState() { super.initState(); Provider.of<ContactController>(context, listen: false).loadAll(); }
  @override
  Widget build(BuildContext context) {
    final ctrl = Provider.of<ContactController>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Postos de Gasolina')),
      body: ListView.builder(
        itemCount: ctrl.contacts.length,
        itemBuilder: (_, i) {
          final c = ctrl.contacts[i];
          return ListTile(
            title: Text(c.name),
            subtitle: Text(c.phone),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ContactForm(contact: c))),
            trailing: IconButton(icon: Icon(Icons.delete), onPressed: () => ctrl.remove(c.id)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ContactForm())), child: Icon(Icons.add)),
    );
  }
}