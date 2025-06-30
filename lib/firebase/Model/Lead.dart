import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  String? id;
  String? name;
  String? email;
  String? phoneNo;
  String? companyName;
  Timestamp? createdAt;

  CustomerModel({
    this.id,
    this.name,
    this.email,
    this.phoneNo,
    this.companyName,
    this.createdAt
  });

  factory CustomerModel.fromJson(Map<String,dynamic>data, String? id) => CustomerModel(
    id: id,
    name: data['name'],
    email: data['email'],
    phoneNo: data['phoneNo'],
    companyName: data['companyName'],
    createdAt: data['createdAt'],
  );

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'phoneNo' : phoneNo ,
    'email' : email,
    'companyName' : companyName,
    'createdAt': createdAt
  };
}