import 'package:flutter/material.dart';
import 'screens/loginscreen.dart';
import 'screens/customerlist.dart';
void main() {
  runApp(const crm());
}

class crm extends StatelessWidget {
  const crm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      title: 'CRM App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  const LoginScreen()
    );
  }
}

