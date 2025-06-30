import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  String? id;
  String? name;
  String? email;
  String? phoneNo;
  String? companyName;
  String? buildingName;
  String? area;
  String? city;
  String? state;
  String? createdBy;
  int? pincode;
  Timestamp? createdAt;

  CustomerModel({
    this.id,
    this.name,
    this.email,
    this.phoneNo,
    this.companyName,
    this.buildingName,
    this.area,
    this.city,
    this.state,
    this.createdBy,
    this.pincode,
    this.createdAt
  });

  factory CustomerModel.fromJson(Map<String,dynamic>data, String? id) => CustomerModel(
    id: id,
    name: data['name'],
    email: data['email'],
    phoneNo: data['phoneNo'],
    companyName: data['companyName'],
    buildingName: data['buildingName'],
    area: data['area'],
    city: data['city'],
    state: data['state'],
    createdBy: data['createdBy'],
    pincode: data['pincode'],
    createdAt: data['createdAt'],
  );

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'phoneNo' : phoneNo ,
    'email' : email,
    'companyName' : companyName,
    'buildingName': buildingName,
    'area': area,
    'city': city,
    'state': state,
    'createdBy': createdBy,
    'pincode': pincode,
    'createdAt': createdAt
  };
}