import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm/firebase/Model/Customer.dart';
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
}