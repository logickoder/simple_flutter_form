class Form {
  final int? id;
  final String title;
  final String name;
  final String email;
  final String phoneNumber;
  final DateTime dateOfBirth;
  final String address;
  final DateTime? createdAt;

  const Form({
    this.id,
    required this.title,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.address,
    this.createdAt,
  });

  factory Form.fromJson(Map<String, dynamic> json) {
    return Form(
      id: json['id'] as int?,
      title: json['title'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      address: json['address'] as String,
      createdAt: DateTime.tryParse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'address': address,
      'created_at': (createdAt ?? DateTime.now()).toIso8601String(),
    };
  }
}
