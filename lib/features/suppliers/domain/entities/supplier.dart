// inventory/lib/models/supplier.dart
class Supplier {
  String id;
  String name;
  String email;
  String phone;
  String address;
  String country;
  String profileUrl;
  String backgroundUrl;
  String ownerId;

  Supplier({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.country,
    this.profileUrl = '',
    this.backgroundUrl = '',
    required this.ownerId,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'country': country,
        'profileUrl': profileUrl,
        'backgroundUrl': backgroundUrl,
        'ownerId': ownerId,
      };

  factory Supplier.fromMap(String id, Map<String, dynamic> map) {
    return Supplier(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      country: map['country'] ?? '',
      profileUrl: map['profileUrl'] ?? '',
      backgroundUrl: map['backgroundUrl'] ?? '',
      ownerId: map['ownerId'] ?? '',
    );
  }
}
