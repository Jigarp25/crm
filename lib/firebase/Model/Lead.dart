import 'package:cloud_firestore/cloud_firestore.dart';

class LeadModel {
  String? id;
  String? title;
  String? email;
  String? phoneNo;
  String? companyName;
  String? status;
  String? customerId;
  String? assignedTo;
  String? description;
  Timestamp? createdAt;

  LeadModel({
    this.id,
    this.title,
    this.email,
    this.phoneNo,
    this.companyName,
    this.status,
    this.customerId,
    this.assignedTo,
    this.description,
    this.createdAt
  });

  factory LeadModel.fromJson(Map<String,dynamic>data, String? id) => LeadModel(
    id: id,
    title: data['title'],
    email: data['email'],
    phoneNo: data['phoneNo'],
    companyName: data['companyName'],
    status: data['status'],
    customerId: data['customerId'],
    assignedTo: data['assignedTo'],
    description: data['description'],
    createdAt: data['createdAt'],
  );

  Map<String, dynamic> toJson() => {
    'id' : id,
    'title' : title,
    'phoneNo' : phoneNo ,
    'email' : email,
    'companyName' : companyName,
    'status' : status,
    'customerId' : customerId,
    'assignedTo' : assignedTo,
    'description' : description,
    'createdAt': createdAt
  };
}