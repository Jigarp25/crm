import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../firebase/Model/User.dart';
import 'package:crm/firebase/Apis.dart';

class AuthController with ChangeNotifier {

  //Controllers for Login
  var txtLoginEmail = TextEditingController();
  var txtLoginPassword = TextEditingController();
  bool obscureLoginPassword = true;

  //Controllers for Register
  var txtRegisterName = TextEditingController();
  var txtRegisterPhoneNo = TextEditingController();
  var txtRegisterEmail = TextEditingController();
  var txtRegisterPassword = TextEditingController();
  var txtRegisterConfirmPassword = TextEditingController();
  var txtRole = TextEditingController();

  void toggleLoginPasswordVisibility(){
    obscureLoginPassword =!obscureLoginPassword;
    notifyListeners();
  }

  void clearLoginFields() {
    txtLoginEmail.clear();
    txtLoginPassword.clear();
  }

  void clearRegisterFields(){
    txtRegisterName.clear();
    txtRegisterEmail.clear();
    txtRegisterPassword.clear();
    txtRegisterConfirmPassword.clear();
    txtRole.clear();
  }

  bool validateRegisterPasswords(){
    return txtRegisterPassword.text == txtRegisterConfirmPassword.text;
  }

  UserModel? currentUser;

  Future<UserModel?> handleLogin()async {
    var email = txtLoginEmail.text.trim();
    var password = txtLoginPassword.text;

    if (email.isEmpty || password.isEmpty)  return null;

    try{
      await API.loginUserInAuth(email, password);

      var result = await API.loginByEmailPassword(email, password);
      if (result.docs.isNotEmpty){
        var doc =result.docs.first;
        currentUser =UserModel.fromJson(doc.data() as Map<String,dynamic>, doc.id);

        var prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userId',currentUser!.id ?? '');
        return currentUser;
      }
    }catch (e) {
      debugPrint('Login error: $e');
    }
    return null;
  }

  Future<String?> handleRegister() async {
    var name = txtRegisterName.text.trim();
    var email = txtRegisterEmail.text.trim();
    var phoneNo = txtRegisterPhoneNo.text.trim();
    var password = txtRegisterPassword.text.trim();
    var role = txtRole.text.trim();

    if(!validateRegisterPasswords()) {return 'password do not match';}

    if (email.isEmpty ||phoneNo.isEmpty|| password.isEmpty || name.isEmpty || role.isEmpty) {
      return 'All fields are required';
    }

    try{
      var uid = await API.createUserInAuth(email, password);
      var user = UserModel(
          id: uid,
          name: name,
          email: email,
          phoneNo: phoneNo,
          password: password,
          role: role,
          createdAt: Timestamp.now()
      );

      await API.addUser(uid, user);
      clearRegisterFields();
      return uid;
    } catch (e) {
      debugPrint('Register error: $e');
      return null;
    }
  }


}