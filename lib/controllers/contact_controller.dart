import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../models/contact.dart';
import '../models/contact_hive.dart';

class ContactController extends ChangeNotifier {
  List<Contact> contacts = [];

  Future<void> loadAll() async {
    final box = DBService().contactsBox;
    contacts = box.values.map((h) => Contact(
      id: h.id,
      name: h.name,
      phone: h.phone,
      email: h.email,
      latitude: h.latitude,
      longitude: h.longitude,
    )).toList();
    notifyListeners();
  }

  Future<void> add(Contact c) async {
    final box = DBService().contactsBox;

    final hive = ContactHive(
      id: c.id,
      name: c.name,
      phone: c.phone,
      email: c.email,
      latitude: c.latitude,
      longitude: c.longitude,
    );

    await box.put(c.id, hive);
    await loadAll();
  }

  Future<void> update(Contact c) async {
    final box = DBService().contactsBox;
    final hive = box.get(c.id);

    if (hive != null) {
      hive.name = c.name;
      hive.phone = c.phone;
      hive.email = c.email;
      hive.latitude = c.latitude;
      hive.longitude = c.longitude;

      await hive.save();
      await loadAll();
    }
  }

  Future<void> remove(String id) async {
    final box = DBService().contactsBox;
    await box.delete(id);
    await loadAll();
  }
}