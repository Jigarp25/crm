import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm/firebase/Model/Customer.dart';
import 'package:crm/firebase/Model/Lead.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'FireStore.dart';
import 'package:crm/firebase/Model/User.dart';

class API{
  static Future<String> createUserInAuth(String email, String password) async{
    return await FireStoreDatabase.createUserInAuth(email, password);
  }
  //Login
  static Future<QuerySnapshot> loginByEmailPassword(String email,String password) async{
    return await FireStoreDatabase.loginByEmailPassword(email, password);
  }

  static Future<UserCredential> loginUserInAuth(String email, String password) async {
    return await FireStoreDatabase.loginUserInAuth(email, password);
  }

  //Add User
  static Future<void> addUser(String id,UserModel data) async{
    return await FireStoreDatabase.addUserDocument(id, data.toJson());
  }
  //Get User
  static Future<UserModel?> getCurrentUser() async{
    var doc = await FireStoreDatabase.fetchCurrentUser();
    return doc.exists ? UserModel.fromJson(doc.data() as Map<String,dynamic>, doc.id): null;
  }
  static Future<void> updateUserPassword(String currentPassword, String newPassword) async {
    await FireStoreDatabase.updateUserPassword(currentPassword, newPassword);
  }
  //get all Users in List
  static Future<Map<String, String>> getUserNamesByIds(List<String> userIds) async {
    var docs = await FireStoreDatabase.fetchUsersByIds(userIds);
    return{
      for (var doc in docs)
        doc.id: ((doc.data() as Map<String, dynamic>)['name'] ?? '' ) as String
    };
  }
  //Add Customer
  static Future<String> addCustomer(CustomerModel data) async{
    return await FireStoreDatabase.addCustomerDocument(data.toJson());
  }
  //Customer List
  static Future<List<CustomerModel>> getAllCustomers() async{
    return await FireStoreDatabase.fetchAllCustomers();
  }

  //Add Lead
  static Future<String> addLead(LeadModel data) async{
    return await FireStoreDatabase.addLeadDocument(data.toJson());
  }

  //Lead List
  static Future<List<LeadModel>> getAllLead() async{
    return await FireStoreDatabase.fetchAllLead();
  }

  //lead status
  static Future<void> updateLeadStatus (String leadId, String newStatus) async{
    return await FireStoreDatabase.updateLeadStatus(leadId, newStatus);
  }

  //get User name
  static Future<List<Map<String, dynamic>>> getAllUserNames() async {
    return await FireStoreDatabase.fetchAllUserNames();
  }

  //get User name
  static Future<List<Map<String, dynamic>>> getAllCustomerNames() async {
    return await FireStoreDatabase.fetchAllCustomerNames();
  }
}