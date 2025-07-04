import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm/firebase/Model/Customer.dart';
import 'package:crm/firebase/Model/Deal.dart';
import 'package:crm/firebase/Model/Lead.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  //Update Password
  static Future<void> updateUserPassword(String currentPassword, String newPassword) async {
   return await FireStoreDatabase.updateUserPassword(currentPassword, newPassword);
  }

  //get assigned lead to user
  static Future<int> getAssignedLeadCount(String userId) async{
    return await FireStoreDatabase.getAssignedLeadCount(userId);
  }

  //get assigned deal to user
  static Future<int> getAssignedDealCount(String userId) async{
    return await FireStoreDatabase.getAssignedDealCount(userId);
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

  //remove customer
  static Future<void> removeCustomer(String id) async {
    await FireStoreDatabase.removeLead(id);
  }

  //Add Lead
  static Future<String> addLead(LeadModel data) async{
    return await FireStoreDatabase.addLeadDocument(data.toJson());
  }

  //Lead List
  static Future<List<LeadModel>> getAllLead() async{
    return await FireStoreDatabase.fetchAllLead();
  }

  //lead status update
  static Future<void> updateLeadStatus (String leadId, String newStatus) async{
    return await FireStoreDatabase.updateLeadStatus(leadId, newStatus);
  }

  //lead Filter
  static Future<List<LeadModel>> getFilteredLeads({String? assignedTo, String? status}) async{
    return await FireStoreDatabase.fetchFilteredLeads(assignedTo: assignedTo,status: status);
  }

  //remove lead
  static Future<void> removeLead(String leadId) async {
    await FireStoreDatabase.removeLead(leadId);
  }

  //get User name
  static Future<List<Map<String, dynamic>>> getAllUserNames() async {
    return await FireStoreDatabase.fetchAllUserNames();
  }

  //get User name
  static Future<List<Map<String, dynamic>>> getAllCustomerNames() async {
    return await FireStoreDatabase.fetchAllCustomerNames();
  }

  //Add Deal
  static Future<String> addDeal(DealModel data) async{
    return await FireStoreDatabase.addDealDocument(data.toJson());
  }

  //deal status update
  static Future<void> updateDealStatus (String dealId, String newStatus) async{
    return await FireStoreDatabase.updateDealStatus(dealId, newStatus );
  }
  //deal amount update
  static Future<void> updateDealAmount(String dealId, double newAmount) async{
    return await FireStoreDatabase.updateDealAmount(dealId, newAmount);
  }

  //deal List
  static Future<List<DealModel>> getAllDeal() async{
    return await FireStoreDatabase.fetchAllDeal();
  }

  //deal Filter
  static Future<List<DealModel>> getFilteredDeals({String? assignedTo, String? status}) async{
    return await FireStoreDatabase.fetchFilteredDeals(assignedTo: assignedTo,status: status);
  }

  //deal close date
  static Future<void> updateDealCloseDate(String dealId, Map<String,dynamic> data) async{
    return await FireStoreDatabase.updateDealClosedDate(dealId,data);
  }

  //remove customer
  static Future<void> removedeal(String id) async {
    await FireStoreDatabase.removeDeal(id);
  }

}