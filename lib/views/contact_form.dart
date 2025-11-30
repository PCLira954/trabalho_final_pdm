import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/contact.dart';
import '../controllers/contact_controller.dart';
import 'package:uuid/uuid.dart';

class ContactForm extends StatefulWidget {
  final Contact? contact;
  ContactForm({this.contact});
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _name.text = widget.contact!.name;
      _phone.text = widget.contact!.phone;
      _email.text = widget.contact!.email ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Provider.of<ContactController>(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.contact == null ? 'Novo contato' : 'Editar contato')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: _name, decoration: InputDecoration(labelText: 'Nome')),
          TextField(controller: _phone, decoration: InputDecoration(labelText: 'Telefone')),
          TextField(controller: _email, decoration: InputDecoration(labelText: 'Email')),
          SizedBox(height: 12),
          ElevatedButton(onPressed: () async {
            final id = widget.contact?.id ?? Uuid().v4();
            final c = Contact(id: id, name: _name.text, phone: _phone.text, email: _email.text.isEmpty ? null : _email.text);
            if (widget.contact == null) await ctrl.add(c); else await ctrl.update(c);
            Navigator.pop(context);
          }, child: Text('Salvar'))
        ]),
      ),
    );
  }
}