import 'package:hive/hive.dart';
part 'contact_hive.g.dart';

@HiveType(typeId: 1)
class ContactHive extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String phone;

  @HiveField(3)
  String? email;

  @HiveField(4)
  double? latitude;

  @HiveField(5)
  double? longitude;

  ContactHive({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.latitude,
    this.longitude,
  });
}