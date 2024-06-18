class UserModel {
  final String name;
  final String contactNumber;
  final String address;
  final String uid;
  final String email;
  UserModel({
    required this.name,
    required this.contactNumber,
    required this.address,
    required this.uid,
    required this.email,
  });

  UserModel copyWith({
    String? name,
    String? contactNumber,
    String? address,
    String? uid,
    String? email,
  }) {
    return UserModel(
      name: name ?? this.name,
      contactNumber: contactNumber ?? this.contactNumber,
      address: address ?? this.address,
      uid: uid ?? this.uid,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'contactNumber': contactNumber,
      'address': address,
      'uid': uid,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      contactNumber: map['contactNumber'] as String,
      address: map['address'] as String,
      uid: map['uid'] as String,
      email: map['email'] as String,
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, contactNumber: $contactNumber, address: $address, uid: $uid, email: $email)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.contactNumber == contactNumber &&
        other.address == address &&
        other.uid == uid &&
        other.email == email;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        contactNumber.hashCode ^
        address.hashCode ^
        uid.hashCode ^
        email.hashCode;
  }
}
