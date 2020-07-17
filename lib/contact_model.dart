class Contact {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String type;
  final String country;

  Contact({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.type,
    this.country,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'type': type,
      'country': country,
    };
  }
}
