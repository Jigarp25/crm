import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'deallist.dart';
import 'leadlist.dart';
import 'customerlist.dart';
import 'profile.dart';

class MainScreen extends StatefulWidget{
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  int _currentIndex = 0;

  final List<Widget> _screens = [
    Dashboard(),
    CustomerList(),
    LeadList(),
    DealList(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xff5B3DDE),
        unselectedItemColor: Colors.grey,
        items: const[
          BottomNavigationBarItem(icon: Icon(Icons.dashboard),label:'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.people),label:'Customers'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment),label:'Leads'),
          BottomNavigationBarItem(icon: Icon(Icons.currency_rupee_outlined),label:'Deals'),
          BottomNavigationBarItem(icon: Icon(Icons.person),label:'profile'),
        ],
      ),
    );
  }
}