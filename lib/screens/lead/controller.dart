import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm/firebase/Apis.dart';
import 'package:crm/firebase/Model/Lead.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LeadController with ChangeNotifier {
  var formKey = GlobalKey<FormState>();

  var txtTitle = TextEditingController();
  var txtCompanyName = TextEditingController();
  var txtEmail = TextEditingController();
  var txtPhone = TextEditingController();
  var txtAssignedTo = TextEditingController();
  var txtDescription = TextEditingController();

  List<LeadModel> leads = [];
  List<LeadModel> filterLeads = [];

  String? selectedCustomerId;
  String? selectedCustomerName;

  String? selectedAssignedTo;
  String? selectedAssignedName;

  String? selectedStatus;

  List<Map<String,String>> customerList =[];
  List<Map<String,String>> assignedUserList =[];

  bool isLoading = false;
  bool isDropdownLoading = true;

  List<String> statusOptions = [
    'New',
    'Contacted',
    'Qualified',
    'Unqualified',
    'Converted',
    'Unconverted',
  ];

  Future<void> loadDropdownData() async {
    try {
      isDropdownLoading= true;
      notifyListeners();

      var usersMap = await API.getAllUserNames();
      assignedUserList = usersMap.map((userMap) => {
        'id':(userMap["id"]??'').toString(),
        'name': (userMap["name"] ??'').toString()
      }).toList();

      for (var user in assignedUserList) {
        debugPrint('User ID: ${user['id']} - Name: ${user['name']}');
      }

      var customerMap = await API.getAllCustomerNames();
      customerList = customerMap.map((customerMap) => {
        'id':(customerMap["id"]??'').toString(),
        'name': (customerMap["name"] ??'').toString()
      }).toList();
      isDropdownLoading =false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching customer list: $e');
    }
  }

  Future<String?> leadSubmit() async {
    if (formKey.currentState?.validate() != true) {
      return 'Please fill all required fields';
    }

    try {
      var firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) return 'User not logged in';

      var lead = LeadModel(
        title: txtTitle.text.trim(),
        companyName: txtCompanyName.text.trim(),
        email: txtEmail.text.trim(),
        phoneNo: txtPhone.text.trim(),
        description: txtDescription.text.trim(),
        status: selectedStatus,
        customerId: selectedCustomerId, // <- using customer ID
        assignedTo: selectedAssignedTo,
        createdAt: Timestamp.now(),
      );

      await API.addLead(lead);
      clearFields();
      return null;
    } catch (e) {
      debugPrint('Lead Add Error: $e');
      return 'Failed to add lead';
    }
  }

  Future<void> loadLeads() async {
    try {
      isLoading = true;
      notifyListeners();

      leads = await API.getAllLead();

      for (var lead in leads) {
        debugPrint('Lead: ${lead.title}, AssignedTo: ${lead.assignedTo}');
      }
    } catch (e) {
      debugPrint('Error fetching leads: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> updateLeadStatus(String leadId, String newStatus) async {
    try {
      await API.updateLeadStatus(leadId, newStatus);

      // also update in local list
      for (var lead in leads){
        if (lead.id == leadId){
          lead.status = newStatus;
          break;
        }
      }

      notifyListeners();
      return null;
    } catch (e) {
      debugPrint('Status update failed: $e');
    }
    return null;
  }

  void clearFields() {
    txtTitle.clear();
    txtCompanyName.clear();
    txtEmail.clear();
    txtPhone.clear();
    txtAssignedTo.clear();
    txtDescription.clear();
    selectedCustomerId = null;
    selectedAssignedTo = null;
    selectedStatus = null;
  }
}
