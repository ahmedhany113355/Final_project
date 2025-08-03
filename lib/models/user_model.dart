import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final String gender;
  final DateTime? birthdate;
  final String? profileImageUrl;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.gender,
    this.birthdate,
    this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'address': address,
      'gender': gender,
      'birthdate': birthdate != null ? Timestamp.fromDate(birthdate!) : null,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      gender: data['gender'] ?? '',
      birthdate: data['birthdate'] != null
          ? (data['birthdate'] as Timestamp).toDate()
          : null,
      profileImageUrl: data['profileImageUrl'],
    );
  }

  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    String? address,
    String? gender,
    DateTime? birthdate,
    String? profileImageUrl,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      birthdate: birthdate ?? this.birthdate,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
