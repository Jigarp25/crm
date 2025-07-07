import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm/firebase/Model/Customer.dart';
import 'package:crm/firebase/Model/Deal.dart';
import 'package:crm/firebase/Model/Lead.dart';
import 'package:crm/firebase/helpers/Dependencies.dart';
import 'package:firebase_auth/firebase_auth.dart'as fa;
import 'package:flutter/material.dart';
import 'DbConstants.dart';

class FireStoreDatabase{

  // static Future<UserCredential> firebaseAuthuser() async {
  //   UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
  //    return userCredential;
  // }
  static Future<String> createUserInAuth(String email,String password) async {
   var result= await fa.FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
   return result.user!.uid;
  }

  static Future<fa.UserCredential> loginUserInAuth(String email, String password) async {
    return await fa.FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<DocumentSnapshot> fetchCurrentUser() async {
    return await FirebaseFirestore.instance
        .collection(Const.userCollection)
        .doc(fa.FirebaseAuth.instance.currentUser!.uid)
        .get();
  }

  static Future<List<DocumentSnapshot>> fetchUsersByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    var snapshots = await Injector.databaseRef!
        .collection(Const.userCollection)
        .where(FieldPath.documentId, whereIn: ids)
        .get();

    return snapshots.docs;
  }

  static Future<int> getAssignedLeadCount(String userId) async{
    var result = await Injector.databaseRef!
        .collection(Const.leadCollection)
        .where(Const.keyAssignTo,isEqualTo: userId)
        .get();

    return result.docs.length;
  }

  static Future<int> getAssignedDealCount(String userId) async{
    var result = await Injector.databaseRef!
        .collection(Const.dealCollection)
        .where(Const.keyAssignTo,isEqualTo: userId)
        .get();

    return result.docs.length;
  }

  static Future<void> updateUserPassword(String currentPassword, String newPassword)async{
    var user = fa.FirebaseAuth.instance.currentUser!;
    var cred = fa.EmailAuthProvider.credential(email: user.email!, password: currentPassword);

    await user.reauthenticateWithCredential(cred);
    await user.updatePassword(newPassword);
    
    await FirebaseFirestore.instance
        .collection(Const.userCollection)
        .doc(user.uid)
        .update({Const.keyUserPassword: newPassword});
  }
  static Future<QuerySnapshot> loginByEmailPassword(String email, String password) async {
    return await Injector.databaseRef!
        .collection(Const.userCollection)
        .where(Const.keyEmail, isEqualTo: email)
        .where(Const.keyUserPassword, isEqualTo: password)
        .get();
  }

  static Future<void> addUserDocument(String id,Map<String,dynamic>data) async {
  await Injector.databaseRef!.collection(Const.userCollection).doc(id).set({...data, Const.keyId: id});
  }

  //Customer
  static Future<String> addCustomerDocument(Map<String,dynamic>data) async {
    DocumentReference docRef = await Injector.databaseRef!
        .collection(Const.customerCollection)
        .add({...data,Const.keyId:''});

    await docRef.update({Const.keyId: docRef.id});
    return docRef.id;
  }

  static Future<List<CustomerModel>> fetchAllCustomers() async{
    var querySnapShot = await Injector.databaseRef!
        .collection(Const.customerCollection)
        .get();
    
    return querySnapShot.docs.map((doc){
      return CustomerModel.fromJson(doc.data(), doc.id);
    }).toList();
  }

  static Future<void> removeCustomer(String id) async{
    await Injector.databaseRef!
        .collection(Const.customerCollection)
        .doc(id)
        .delete();
  }


  // Lead
  static Future<String> addLeadDocument(Map<String,dynamic>data) async {
    DocumentReference docRef = await Injector.databaseRef!
        .collection(Const.leadCollection)
        .add({...data, Const.keyId: ''});

    await docRef.update({Const.keyId: docRef.id});
    return docRef.id;
  }

  static Future<List<LeadModel>> fetchAllLead() async {
    var querySnapShot = await Injector.databaseRef!
        .collection(Const.leadCollection)
        .get();

    return querySnapShot.docs.map((doc){
      return LeadModel.fromJson(doc.data(), doc.id);
    }).toList();
  }

  static Future<void> updateLeadStatus(String leadId, String newStatus) async {
    try {
      await Injector.databaseRef!.collection(Const.leadCollection).doc(leadId).update(
          {Const.keyStatus: newStatus});
    }catch (e){
      debugPrint('Error updating lead status: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchAllCustomerNames() async {
    var snapshot = await Injector.databaseRef!
        .collection(Const.customerCollection)
        .get();

    return snapshot.docs.map((doc){
      var data = doc.data();
      return{
        'id':doc.id,
        'name':data[Const.keyName]?? 'Unnamed',
      };
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> fetchAllUserNames() async {
    var snapshot = await Injector.databaseRef!
        .collection(Const.userCollection)
        .get();

    return snapshot.docs.map((doc){
      var data = doc.data();
      return{
        'id':doc.id,
        'name':data[Const.keyName]?? 'Unnamed',
      };
    }).toList();
  }

  static Future<void> removeLead(String leadId) async{
    await Injector.databaseRef!
        .collection(Const.leadCollection)
        .doc(leadId)
        .delete();
  }

  static Future<List<LeadModel>> fetchFilteredLeads({String? assignedTo, String? status}) async{
    Query<Map<String, dynamic>> query =Injector.databaseRef!.collection(Const.leadCollection);

    if(assignedTo != null)
      query = query.where(Const.keyAssignTo, isEqualTo: assignedTo);
    if(status != null)
      query = query.where(Const.keyStatus, isEqualTo: status);

    var snapshot = await query.get();
    return snapshot.docs.map((doc) => LeadModel.fromJson(doc.data(), doc.id)).toList();
  }

  //Deal
  static Future<String> addDealDocument(Map<String,dynamic>data) async {
    DocumentReference docRef = await Injector.databaseRef!
        .collection(Const.dealCollection)
        .add({...data, Const.keyId: ''});

    await docRef.update({Const.keyId: docRef.id});
    return docRef.id;
  }

  static Future<void> removeDeal(String id) async{
    await Injector.databaseRef!
        .collection(Const.dealCollection)
        .doc(id)
        .delete();
  }

  static Future<List<DealModel>> fetchAllDeal() async {
    var querySnapShot = await Injector.databaseRef!
        .collection(Const.dealCollection)
        .get();

    return querySnapShot.docs.map((doc) {
      return DealModel.fromJson(doc.data(), doc.id);
    }).toList();
  }

  static Future<void> updateDealStatus(String dealId, String newStatus) async {
    try {
      await Injector.databaseRef!.collection(Const.dealCollection).doc(dealId).update(
          {Const.keyStatus: newStatus});
    }catch (e){
      debugPrint('Error updating deal status: $e');
      rethrow;
    }
  }

  static Future<void> updateDealAmount(String dealId, double newAmount) async {
    try {
      await Injector.databaseRef!.collection(Const.dealCollection).doc(dealId).update(
          {Const.keyAmount: newAmount});
    }catch (e){
      debugPrint('Error updating deal Amount: $e');
      rethrow;
    }
  }

  static Future<List<DealModel>> fetchFilteredDeals({String? assignedTo, String? status}) async{
    Query<Map<String, dynamic>> query =Injector.databaseRef!.collection(Const.dealCollection);

    if(assignedTo != null)
      query = query.where(Const.keyAssignTo, isEqualTo: assignedTo);
    if(status != null)
      query = query.where(Const.keyStatus, isEqualTo: status);

    var snapshot = await query.get();
    return snapshot.docs.map((doc) => DealModel.fromJson(doc.data(), doc.id)).toList();
  }

  // static Future<List<QueryDocumentSnapshot<Map<String,dynamic>>>> searchDeals(String query) async {
  //   var snapshot = await Injector.databaseRef!
  //       .collection(Const.dealCollection)
  //       .where(Const.keyTitle, isGreaterThanOrEqualTo: query)
  //       .where(Icons.title,isLessThanOrEqualTo: query + '\uf8ff')
  //       .get();
  //
  //   return snapshot.docs;
  // }

  static Future<void> updateDealClosedDate(String dealId, Map<String,dynamic> data)async{
    await Injector.databaseRef!
        .collection(Const.dealCollection)
        .doc(dealId)
        .update(data);
  }

  static Future<void> addNote({required String parentCollection,required String parentId, required Map<String,dynamic> noteData}) async{
    await Injector.databaseRef!
        .collection(parentCollection)
        .doc(parentId)
        .collection(Const.noteSubCollection)
        .add(noteData);
  }

  static Future<List<Map<String, dynamic>>> fetchNote({required String parentCollection,required String parentId}) async{
   var snapshot= await Injector.databaseRef!
       .collection(parentCollection)
       .doc(parentId)
       .collection(Const.noteSubCollection)
       .orderBy(Const.keyCreatedAt, descending: true)
       .get();

   return snapshot.docs.map((doc) => {...doc.data(),'id':doc.id}).toList();
  }

  static Future<void> deleteNote({required String parentCollection,required String parentId,required String noteId}) async{
    await Injector.databaseRef!
       .collection(parentCollection)
       .doc(parentId)
       .collection(Const.noteSubCollection)
       .doc(noteId)
       .delete();
  }

  static Future<void> updateNote({required String parentCollection, required String parentId, required String noteId, required Map<String, dynamic> updatedData,}) async {
    try {
      await Injector.databaseRef!
          .collection(parentCollection)
          .doc(parentId)
          .collection(Const.noteSubCollection)
          .doc(noteId)
          .update(updatedData);
    } catch (e) {
      debugPrint('Error updating note: $e');
      rethrow;
    }
  }


}