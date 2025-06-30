import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? phoneNo;
  String? role;
  String? password;
  Timestamp? createdAt;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phoneNo,
    this.role,
    this.password,
    this.createdAt
  });

  factory UserModel.fromJson(Map<String,dynamic>data, String? id) => UserModel(
    id: id,
    name: data['name'],
    email: data['email'],
    phoneNo: data['phoneNo'],
    role: data['role'],
    password: data['password'],
    createdAt: data['createdAt'],
  );

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'phoneNo' : phoneNo ,
    'email' : email,
    'role' : role,
    if (password != null) 'password': password,
    'createdAt': createdAt
  };
}