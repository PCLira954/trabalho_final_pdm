class Contact {
  final String id;
  String name;
  String phone;
  String? email;
  double? latitude;
  double? longitude;

  Contact({required this.id, required this.name, required this.phone, this.email, this.latitude, this.longitude});

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'latitude': latitude,
        'longitude': longitude,
      };

  factory Contact.fromMap(Map<String, dynamic> m) => Contact(
        id: m['id'],
        name: m['name'],
        phone: m['phone'],
        email: m['email'],
        latitude: m['latitude'] != null ? (m['latitude'] as num).toDouble() : null,
        longitude: m['longitude'] != null ? (m['longitude'] as num).toDouble() : null,
      );
}