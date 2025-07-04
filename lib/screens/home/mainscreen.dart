import 'package:flutter/material.dart';
import 'dashboard.dart';
import '../deal/deallist.dart';
import '../lead/leadlist.dart';
import '../customer/customerlist.dart';
import '../profile/profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  List<Widget> get _screens => [
    //Dashboard(),
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
        selectedItemColor: const Color(0xff5B3DDE),
        unselectedItemColor: Colors.grey.shade700,
        items: const [
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.dashboard_outlined),
          //   label: 'Dashboard',
          //   activeIcon: Icon(Icons.dashboard)
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: 'Customers',
            activeIcon:Icon(Icons.people_alt)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: 'Leads',
            activeIcon: Icon(Icons.assignment)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.currency_rupee),
              label: 'Deals',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              label: 'Profile',
            activeIcon: Icon(Icons.person)
          ),
        ],
      ),
    );
  }
}
