import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:crm/firebase/Model/Customer.dart';
import 'package:crm/firebase/Apis.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerController with ChangeNotifier {
  // Form fields
  var formKey = GlobalKey<FormState>();
  var txtName = TextEditingController();
  var txtEmail = TextEditingController();
  var txtPhoneNo = TextEditingController();
  var txtCompanyName = TextEditingController();
  var txtBuildingName = TextEditingController();
  var txtArea = TextEditingController();
  var txtCity = TextEditingController();
  var txtState = TextEditingController();
  var txtPincode = TextEditingController();

  void clearFields() {
    txtName.clear();
    txtEmail.clear();
    txtPhoneNo.clear();
    txtCompanyName.clear();
    txtBuildingName.clear();
    txtArea.clear();
    txtCity.clear();
    txtState.clear();
    txtPincode.clear();
  }

  // This is the only list you'll maintain
  List<CustomerModel> customers = [];

  bool isLoading = false;

  // Search helper
  List<CustomerModel> searchCustomers(String query) {
    return customers
        .where((c) => (c.name ?? '')
        .toLowerCase()
        .contains(query.toLowerCase()))
        .toList();
  }

  // Submit customer
  Future<String?> submitCustomerForm() async {
    if (txtName.text.trim().isEmpty ||
        txtPhoneNo.text.trim().isEmpty ||
        txtCompanyName.text.trim().isEmpty ||
        txtPincode.text.trim().isEmpty) {
      return 'Please fill all required fields';
    }

    try {
      var firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) return 'User not logged in';

      var customer = CustomerModel(
        name: txtName.text.trim(),
        email: txtEmail.text.trim(),
        phoneNo: txtPhoneNo.text.trim(),
        companyName: txtCompanyName.text.trim(),
        buildingName: txtBuildingName.text.trim(),
        area: txtArea.text.trim(),
        city: txtCity.text.trim(),
        state: txtState.text.trim(),
        pincode: int.tryParse(txtPincode.text.trim()),
        createdBy: firebaseUser.uid,
        createdAt: Timestamp.now(),
      );

      await API.addCustomer(customer);
      clearFields();
      await loadCustomers();
      return null;
    } catch (e) {
      debugPrint('Customer Add Error: $e');
      return 'Failed to add customer';
    }
  }

  // Load all customers
  Future<void> loadCustomers() async {
    try {
      isLoading = true;
      notifyListeners();
      customers = await API.getAllCustomers();
    } catch (e) {
      debugPrint('Error fetching customers: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
