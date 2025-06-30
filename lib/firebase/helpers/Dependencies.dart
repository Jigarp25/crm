import 'package:cloud_firestore/cloud_firestore.dart';

class Injector{
  static FirebaseFirestore? databaseRef;

  static Future<void> initialize() async {
    databaseRef = FirebaseFirestore.instance;
  }
}