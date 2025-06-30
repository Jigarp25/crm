import 'package:crm/firebase/helpers/Dependencies.dart';
import 'package:crm/screens/customer/controller.dart';
import 'package:crm/screens/lead/controller.dart';
import 'package:crm/screens/profile/controller.dart';
import 'package:flutter/material.dart';
import 'screens/auth/loginscreen.dart';
import 'package:provider/provider.dart';
import 'screens/auth/controller.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await Injector.initialize();

  runApp(
    MultiProvider(
        providers:[
          ChangeNotifierProvider(create: (_) => AuthController()),
          ChangeNotifierProvider(create: (_) => CustomerController()),
          ChangeNotifierProvider(create: (_) => ProfileController()),
          ChangeNotifierProvider(create: (_) => LeadController()),
        ],
        child: const crm()
    ),
  );
}

class crm extends StatelessWidget {
  const crm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRM App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home:  LoginScreen()
    );
  }
}

