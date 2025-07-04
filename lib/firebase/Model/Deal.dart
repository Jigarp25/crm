import 'package:cloud_firestore/cloud_firestore.dart';

class DealModel{
  String? id;
  String? title;
  String? description;
  String? companyName;
  String? status;
  String? customerId;
  String? leadId;
  String? assignedTo;
  double? amount;
  Timestamp? createdAt;
  Timestamp? closedDate;

  DealModel({
    this.id,
    this.title,
    this.description,
    this.companyName,
    this.status,
    this.customerId,
    this.assignedTo,
    this.leadId,
    this.amount,
    this.createdAt,
    this.closedDate,
  });

  factory DealModel.fromJson(Map<String,dynamic>data, String? id) => DealModel(
    id: id,
    title: data['title'],
    description: data['description'],
    companyName: data['companyName'],
    status: data['status'],
    customerId: data['customerId'],
    leadId: data['leadId'],
    assignedTo: data['assignedTo'],
    amount: data['amount'],
    createdAt: data['createdAt'],
    closedDate: data['closedDate'],
  );

  Map<String,dynamic> toJson() => {
  'id': id,
  'title': title,
  'description': description,
  'companyName': companyName,
  'status': status,
  'customerId': customerId,
  'leadId': leadId,
  'assignedTo': assignedTo,
  'amount': amount,
  'createdAt': createdAt,
  'closedDate': closedDate,
  };
}
