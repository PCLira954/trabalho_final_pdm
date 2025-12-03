import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import '../models/contact.dart';
import '../controllers/contact_controller.dart';

class ContactForm extends StatefulWidget {
  final Contact? contact;
  ContactForm({this.contact});

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _latitude = TextEditingController();
  final _longitude = TextEditingController();

  bool _gettingLocation = false;

  @override
  void initState() {
    super.initState();

    if (widget.contact != null) {
      _name.text = widget.contact!.name;
      _phone.text = widget.contact!.phone;
      _email.text = widget.contact!.email ?? '';
      _latitude.text = widget.contact!.latitude?.toString() ?? '';
      _longitude.text = widget.contact!.longitude?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _latitude.dispose();
    _longitude.dispose();
    super.dispose();
  }

  
  Future<void> _useCurrentLocation() async {
    setState(() => _gettingLocation = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showMessage('Serviço de localização desativado no dispositivo.');
        setState(() => _gettingLocation = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        _showMessage('Permissões de localização negadas permanentemente.');
        setState(() => _gettingLocation = false);
        return;
      }

      final pos = await Geolocator.getCurrentPosition();
      _latitude.text = pos.latitude.toString();
      _longitude.text = pos.longitude.toString();
    } catch (e) {
      _showMessage('Erro ao obter localização: $e');
    } finally {
      setState(() => _gettingLocation = false);
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  
  double? _parseCoordinate(String s) {
    final t = s.trim();
    if (t.isEmpty) return null;
    
    final normalized = t.replaceAll(',', '.');
    return double.tryParse(normalized);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final lat = _parseCoordinate(_latitude.text);
    final lng = _parseCoordinate(_longitude.text);

    
    
    if ((_latitude.text.trim().isNotEmpty && lat == null) ||
        (_longitude.text.trim().isNotEmpty && lng == null)) {
      _showMessage('Latitude ou longitude inválida. Use formato numérico (ex: -5.08921).');
      return;
    }

    final id = widget.contact?.id ?? Uuid().v4();
    final contact = Contact(
      id: id,
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      email: _email.text.trim().isEmpty ? null : _email.text.trim(),
      latitude: lat,
      longitude: lng,
    );

    final ctrl = Provider.of<ContactController>(context, listen: false);

    try {
      if (widget.contact == null) {
        await ctrl.add(contact);
      } else {
        await ctrl.update(contact);
      }
      Navigator.pop(context);
    } catch (e) {
      _showMessage('Erro ao salvar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact == null ? 'Novo Posto' : 'Editar Posto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              
              TextFormField(
                controller: _name,
                decoration: InputDecoration(labelText: 'Nome do Posto'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
              ),

              
              TextFormField(
                controller: _phone,
                decoration: InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
              ),

              
              TextFormField(
                controller: _email,
                decoration: InputDecoration(labelText: 'Email (opcional)'),
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 12),

              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _latitude,
                      decoration: InputDecoration(
                        labelText: 'Latitude',
                        hintText: '-5.08921',
                        helperText: 'Digite manualmente ou use o botão abaixo',
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return null; 
                        final val = _parseCoordinate(v);
                        return val == null ? 'Latitude inválida' : null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _longitude,
                      decoration: InputDecoration(
                        labelText: 'Longitude',
                        hintText: '-42.80164',
                        helperText: 'Digite manualmente ou use o botão abaixo',
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return null; 
                        final val = _parseCoordinate(v);
                        return val == null ? 'Longitude inválida' : null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _gettingLocation ? null : _useCurrentLocation,
                    icon: _gettingLocation ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : Icon(Icons.my_location),
                    label: Text(_gettingLocation ? 'Obtendo...' : 'Usar localização atual'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Ou digite latitude e longitude manualmente.',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),

              Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}