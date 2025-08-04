import 'package:crm/utils/ui_utils.dart';
import 'package:crm/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import '../auth/controller.dart';
import '../../widgets/buttons.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

typedef RoleEntry= DropdownMenuEntry<UserRole>;

enum UserRole {
  admin('Admin', 1),
  manager('Manager', 2),
  staff('Staff', 3);

  const UserRole(this.label, this.value);

  final String label;
  final int value;


  static final List<RoleEntry> entries = UnmodifiableListView<RoleEntry>(
    UserRole.values.map<RoleEntry>(
      (UserRole role)=> RoleEntry(
        value: role,
        label: role.label,
      ),
    ),
  );
}

class _RegisterState extends State<Register>{
  final _formKey = GlobalKey<FormState>();

  UserRole? selectedRole;

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name',textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18)),
              TextFormField(
                controller: auth.txtRegisterName,
                decoration: inputDecoration(hint: 'Enter Your Name'),
              ),
              vSpace(16),
              Text('E-mail',textAlign: TextAlign.left, style: TextStyle( fontSize: 18)),
              TextFormField(
                  validator: (value) => Validators.validateEmail(value),
                  controller: auth.txtRegisterEmail,
                decoration: inputDecoration(hint: 'Enter Your E-mail')
              ),
              vSpace(16),
              Text('Phone No.',textAlign: TextAlign.left, style: TextStyle( fontSize: 18)),
              IntlPhoneField(
                decoration: inputDecoration(hint: 'Phone No'),
                initialCountryCode: 'IN',
                onChanged: (phone){
                  auth.txtRegisterPhoneNo.text = phone.completeNumber;
                },
              ),
              vSpace(16),
              Text('Role',textAlign: TextAlign.left,
                  style: TextStyle( fontSize: 18)),
              Container(
                  alignment: Alignment.centerLeft,
                  child: DropdownMenu<UserRole>(
                      controller: auth.txtRole,
                      dropdownMenuEntries: UserRole.entries,
                      onSelected:(UserRole? role){
                        setState(() {
                          selectedRole = role ;
                          if(role != null){
                            auth.txtRole.text = role.label;
                          }
                        });
                      },
                    menuStyle: MenuStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      elevation: WidgetStatePropertyAll(2)
                    ),
                    inputDecorationTheme: InputDecorationTheme(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  )
              ),
              vSpace(16),
              Text('Create Password',textAlign: TextAlign.left,
                  style: TextStyle( fontSize: 18)),
              TextFormField(
                controller: auth.txtRegisterPassword,
                obscureText: auth.obscureCreatePassword,
                decoration: InputDecoration(
                  fillColor: Color(0xffffffff),
                  filled: true,
                    hintText: 'Create Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)
                    ),
                  suffixIcon: IconButton(
                    icon: Icon(auth.obscureCreatePassword ? Icons.visibility_off : Icons.visibility ),
                    onPressed: auth.toggleCreatePasswordVisiblity,
                  ),
                  errorStyle: TextStyle(fontSize: 16, color: Colors.red),
                ),
                validator: (value) => Validators.validatePassword(value ?? ''),
              ),
              vSpace(16),
              Text('Confirm Password',textAlign: TextAlign.left,
                  style: TextStyle( fontSize: 18)),
              TextFormField(
                controller: auth.txtRegisterConfirmPassword,
                obscureText:auth.obscureConfirmPassword,
                decoration: InputDecoration(
                  fillColor: Color(0xffffffff),
                  filled: true,
                    hintText: 'Re-enter Your Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                    ),
                  suffixIcon: IconButton(
                    icon: Icon(auth.obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,),
                    onPressed: auth.toggleConfirmPasswordVisiblity,
                  ),
                  errorStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                  overflow: TextOverflow.visible
                  ),
                ),
                validator: (value) {
                  if (value != auth.txtRegisterPassword.text){
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              vSpace(16),
              SizedBox(
                width: double.infinity,
                child: elevatedButton(
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      var id = await auth.handleRegister();
                      if (id !=null) {
                        auth.clearRegisterFields();
                        Navigator.pop(context);
                      }
                      // submit the form
                      }else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registration failed')),
                        );
                      }
                    },
                  label:'Register',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}