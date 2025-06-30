// lib/screens/login_screen.dart
import 'package:crm/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import '../../widgets/buttons.dart';
import 'register.dart';
import '/utils/ui_utils.dart';
import 'package:provider/provider.dart';
import '../auth/controller.dart';
import '../home/mainscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthController>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              vSpace( 40),
              Image.asset(
                'assets/images/logo.jpg',
                height: 100,
                width: 100,
              ),
              vSpace(),
              const Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              vSpace(),
              TextFormField(
                controller: auth.txtLoginEmail,
                validator: (value) => Validators.validateEmail(value),
                decoration: inputDecoration(hint: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              vSpace(),
              TextField(
                controller: auth.txtLoginPassword,
                obscureText: auth.obscureLoginPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  fillColor: Color(0xffffffff),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      auth.obscureLoginPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: auth.toggleLoginPasswordVisibility,
                  ),
                ),
              ),
              textButton(
                  label: 'Forgot Password ?', onPressed: () async {
                    //todo: navigate to reset password
                  },
                alignment: Alignment.topRight
              ),
              SizedBox(
                width: double.infinity,
                child: elevatedButton(
                  onPressed:() async {
                    var user = await auth.handleLogin();
                    if (user != null) {
                      auth.clearLoginFields();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const MainScreen(),)
                      );
                    }else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid login credentials')),
                      );
                    }
                  },
                  label:'Login',
                ),
              ),
              Center(
                child: textButton(
                  onPressed: () async {
                    // navigate to register page
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Register() ),);
                  },
                  label:"Don't have an account? Register here",
                  alignment: Alignment.center
                ),
              ),
              vSpace(),
            ],
          ),
        ),
      ),
    );
  }
}
