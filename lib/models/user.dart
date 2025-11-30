class User {
  String id;
  String email;
  String passwordHash;

  User({required this.id, required this.email, required this.passwordHash});

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'passwordHash': passwordHash,
      };

  factory User.fromMap(Map<String, dynamic> map) => User(
        id: map['id'],
        email: map['email'],
        passwordHash: map['passwordHash'],
      );
}