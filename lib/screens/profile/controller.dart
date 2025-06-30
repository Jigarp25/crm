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



  /*Future<String?> updatePassword() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) return 'User not logged in';

      var cred = EmailAuthProvider.credential(
        email: user.email!,
        password: txtcurrentPassword.text.trim(),
      );

      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(txtnewPassword.text.trim());
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user.email!,
        password: txtnewPassword.text.trim(),
      );
      debugPrint('Login with new password successful');
      await user.reload();
      await FirebaseAuth.instance.signOut();
      clearFields();
      return null; // success
    } catch (e) {
      debugPrint('Update Password Error: $e');
      return 'Failed to update password';
    }
  }*/

  void clearFields(){
    txtnewPassword.clear();
    txtcurrentPassword.clear();
    txtemail.clear();
    txtconfirmPassword.clear();
    txtname.clear();
    txtProfilePassword.clear();
  }


}