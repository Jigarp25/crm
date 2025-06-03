import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

typedef roleEntry= DropdownMenuEntry<userRole>;

enum userRole {
  admin('Admin', 1),
  manager('Manager', 2),
  staff('Staff', 3);

  const userRole(this.label, this.value);

  final String label;
  final int value;


  static final List<roleEntry> entries = UnmodifiableListView<roleEntry>(
    userRole.values.map<roleEntry>(
          (userRole role) =>
          roleEntry(
            value: role,
            label: role.label,
          ),
    ),
  );
}
class _RegisterState extends State<Register>{
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController =TextEditingController();

  final TextEditingController roleController = TextEditingController();
  userRole? selectedRole;

  final _createPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? validatePassword(String password){
    if (password.length < 6) return 'Password must be at lest 6 characters ';
    if (!RegExp(r'[A-Z]').hasMatch(password)) return 'Must contain Uppercase letter';
    if (!RegExp(r'[a-z]').hasMatch(password)) return 'Must contain Lowercase letter';
    if (!RegExp(r'\d').hasMatch(password)) return 'Must contain a number';
    if (!RegExp(r'[!@#%^&*?]').hasMatch(password)) return 'Must contain a special character';
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: 'E-Mail',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)
                    )
                ),
              ),
              const SizedBox(height: 16),
              Container(
                  alignment: Alignment.centerLeft,
                  child: DropdownMenu<userRole>(
                      controller: roleController,
                      label: const Text("Select Role"),
                      dropdownMenuEntries: userRole.entries,
                      onSelected:(userRole? role){
                        setState(() {
                          selectedRole = role;
                        });
                      }
                  )
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _createPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Create Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)
                    ),
                  errorStyle: TextStyle(fontSize: 16, color: Colors.red),
                ),
                validator: (value) => validatePassword(value ?? ''),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText:true,
                decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                    ),
                  errorStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                  overflow: TextOverflow.visible

                  ),
                ),
                validator: (value) {
                  if (value != _createPasswordController.text){
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff5b3dde),
                      minimumSize: Size(60, 50)
                    ),
                    onPressed: (){
                      if(_formKey.currentState!.validate()){
                        //TODO: submit the form
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Submitting registration...')),
                        );
                        Future.delayed(const Duration(seconds:1),(){
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white,fontSize: 20),
                    ),
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}