class Password {
  final String id;
  final String title;
  final String email;
  final String password;

  Password(
      {required this.id,
      required this.title,
      required this.email,
      required this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'email': email,
      'password': password,
    };
  }

  factory Password.fromMap(Map<String, dynamic> map) {
    return Password(
      id: map['id'] ?? '', // Provide a default value if null
      title: map['title'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }
}
