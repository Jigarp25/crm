import 'package:crm/firebase/Apis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../firebase/Model/User.dart';

class ProfileController with ChangeNotifier {
  var formKey = GlobalKey<FormState>();
  var txtname = TextEditingController();
  var txtemail = TextEditingController();
  var txtProfilePassword = TextEditingController();
  var txtcurrentPassword = TextEditingController();
  var txtnewPassword = TextEditingController();
  var txtconfirmPassword = TextEditingController();

  bool isPasswordVisible = false;
  bool isCurrentPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  int assignedLeadsCount = 0;
  int assignedDealsCount = 0;

  void toggelVisibility (String field) {
    switch (field) {
      case 'current':
        isCurrentPasswordVisible = !isCurrentPasswordVisible;
        break;
      case 'new':
        isPasswordVisible = !isPasswordVisible;
        break;
      case 'confirm':
        isConfirmPasswordVisible = !isConfirmPasswordVisible;
        break;
    }
    notifyListeners();
  }

  UserModel? currentUser;

  Future<void> loadProfile() async {
    try {
      var user = await API.getCurrentUser();
      if (user != null){
        currentUser = user;
        txtname.text = user.name ?? '';
        txtemail.text = user.email ?? '';

        assignedLeadsCount =await API.getAssignedLeadCount(user.id!);
        assignedDealsCount = await API.getAssignedDealCount(user.id!);

        notifyListeners();
      }
    }catch(e){
      debugPrint('Load Profile Error: $e');
    }
  }

  Future<String?> updatePassword(String currentPassword, String newPassword) async {
    try {
      if (currentPassword == newPassword){
        return 'New Password must be different from current password';
      }
      await API.updateUserPassword(currentPassword, newPassword);
      return null;
    }on FirebaseAuthException catch(e){
      debugPrint("FirebaseAuthException: ${e.code} - ${e.message}");
      return e.message ?? 'Password update failed.';
    }
    catch (e) {
      debugPrint("Unexpected error:: $e");
      return 'Something went wrong: ${e.toString()}';
    }
  }

  void clearFields(){
    txtnewPassword.clear();
    txtcurrentPassword.clear();
    txtemail.clear();
    txtconfirmPassword.clear();
    txtname.clear();
    txtProfilePassword.clear();
  }


}