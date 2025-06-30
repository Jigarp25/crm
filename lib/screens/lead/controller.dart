import 'package:flutter/material.dart';
import '../../../services/dummydata.dart';

class LeadController with ChangeNotifier {
  var formKey = GlobalKey<FormState>();

  var txtTitle = TextEditingController();
  var txtCompanyName = TextEditingController();
  var txtEmail = TextEditingController();
  var txtPhone = TextEditingController();
  var txtAssignedTo = TextEditingController();
  var txtDescription = TextEditingController();
// Inside class LeadController
  List<String> customerList = [];
  List<String> assignedUserList = [];

  String? selectedCustomer;
  String? selectedAssignedTo;
  String? selectedStatus;

  List<String> get customer =>
      Dummydata.allCustomers.map((e) => e['name'] ?? '').toList();

  List<Map<String, String>> get userNames => Dummydata.allUser;

  List<String> statusOptions = [
    'Qualified',
    'Unqualified',
    'Converted',
    'Unconverted',
  ];

  void setSelectedCustomer(String? name) {
    selectedCustomer = name;
    notifyListeners();
  }

  void setSelectedAssignedTo(String? user) {
    selectedAssignedTo = user;
    txtAssignedTo.text = user ?? '';
    notifyListeners();
  }

  void setSelectedStatus(String? status) {
    selectedStatus = status;
    notifyListeners();
  }
  void setCustomerList(List<String> list) {
    customerList = list;
    notifyListeners(); // if needed
  }

  void setAssignedUserList(List<String> list) {
    assignedUserList = list;
    notifyListeners(); // if needed
  }

  void onCustomerSelected(String name) {
    selectedCustomer = name;
    notifyListeners(); // if using Consumer widgets
  }


  void clearFields() {
    txtTitle.clear();
    txtCompanyName.clear();
    txtEmail.clear();
    txtPhone.clear();
    txtAssignedTo.clear();
    txtDescription.clear();
    selectedCustomer = null;
    selectedAssignedTo = null;
    selectedStatus = null;
  }
}
