import 'package:crm/screens/auth/loginscreen.dart';
import 'package:crm/screens/profile/controller.dart';
import 'package:crm/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/validators.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePassword();
}

class _UpdatePassword extends State<UpdatePassword> {
  late ProfileController controller;

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    controller = Provider.of<ProfileController>(context);
  }

  void clear() {
    controller.clearFields();
  }

  void _submit() async {
    if (!controller.formKey.currentState!.validate()) return;

    String currentPassword =controller.txtcurrentPassword.text.trim();
    String newPassword =controller.txtnewPassword.text.trim();

    var result = await controller.updatePassword(currentPassword , newPassword);

    if (!mounted) return;
    
    if (result == null) {
      controller.clearFields();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully')),
      );
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder:(_) => LoginScreen()),(route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Password')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  text: 'Current Password',
                  style: TextStyle(fontSize: 19, color: Color(0xff000000)),
                  children: [
                    TextSpan(
                      text: '*',
                      style: TextStyle(color: Color(0xffff0000)),
                    )
                  ],
                ),
              ),
              TextFormField(
                controller: controller.txtcurrentPassword,
                obscureText: _obscureCurrent,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffffffff),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureCurrent ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    ),
                    onPressed: () {
                      setState(() => _obscureCurrent = !_obscureCurrent);
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your current password';
                  return null;
                },
              ),
              vSpace(),
              const Text('New Password', textAlign: TextAlign.left, style: TextStyle(fontSize: 18)),
              TextFormField(
                controller: controller.txtnewPassword,
                obscureText: _obscureNew,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffffffff),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  errorStyle: const TextStyle(
                    fontSize: 16,
                    color: Color(0xffff0000),
                    overflow: TextOverflow.visible,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNew ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    ),
                    onPressed: () {
                      setState(() => _obscureNew = !_obscureNew);
                    },
                  ),
                ),
                  validator: (value) => Validators.validatePassword(value ?? '')
              ),
              vSpace(),
              const Text('Confirm New Password', textAlign: TextAlign.left, style: TextStyle(fontSize: 18)),
              TextFormField(
                controller: controller.txtconfirmPassword,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffffffff),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  errorStyle: const TextStyle(
                    fontSize: 16,
                    color: Color(0xffff0000),
                    overflow: TextOverflow.visible,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    ),
                    onPressed: () {
                      setState(() => _obscureConfirm = !_obscureConfirm);
                    },
                  ),
                ),
                validator: (value) {
                  if (value != controller.txtnewPassword.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              vSpace(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff5b3dde),
                    minimumSize: const Size(60, 50),
                  ),
                  onPressed: _submit ,
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Color(0xffffffff), fontSize: 20),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top:24),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xfff7f7f7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color:Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Password must meet the following:",style: TextStyle(fontWeight: FontWeight.bold)),
                    vSpace(8),
                    Text("• Password should be at least 6 characters long",style: TextStyle(color: Colors.black)),
                    Text("• Contain all of the following 4:",style: TextStyle(color: Colors.black)),
                    Padding(
                      padding: EdgeInsets.only(left:16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("- Uppercase letters (A-Z)",style: TextStyle(color: Colors.black)),
                          Text("- Lowercase letters (a-z)",style: TextStyle(color: Colors.black)),
                          Text("- Numbers (0-9)",style: TextStyle(color: Colors.black)),
                          Text("- Special characters(!@#%^&*etc.)",style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                    vSpace(8),
                    Text("• New Password must be different from current paswword", style: TextStyle(color: Colors.black)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
