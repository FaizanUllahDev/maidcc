import 'dart:convert';

class UserEntity {
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? phone;
  String? address;
  String? gender;
  num? balance;
  bool? isVerified;

  UserEntity({
    this.id,
    this.username,
    this.email,
    this.password,
    this.phone,
    this.address,
    this.gender,
    this.isVerified,
    this.firstName,
    this.lastName,
    this.balance,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'phone': phone,
      'address': address,
      'gender': gender,
      'is_verified': isVerified,
      'balance': balance,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['id'] ?? -1,
      username: map['username'] ?? '-',
      email: map['email'] ?? '-',
      password: map['password'] ?? '-',
      phone: map['phone'] ?? '-',
      address: map['address'] ?? '-',
      gender: map['gender'] ?? '-',
      isVerified: map['is_verified'] ?? false,
      balance: map['balance'] ?? 0.0,
      firstName: map['firstName'] ?? '-',
      lastName: map['lastName'] ?? '-',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserEntity.fromJson(String source) {
    return UserEntity.fromMap(json.decode(source));
  }


  // to string
  @override
  String toString() {
    return 'UserEntity(id: $id, username: $username, email: $email, password: $password, phone: $phone, address: $address, gender: $gender, isVerified: $isVerified, balance: $balance, firstName: $firstName, lastName: $lastName)';
  }

}
