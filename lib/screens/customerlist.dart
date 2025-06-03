import 'package:flutter/material.dart';
import '/screens/addcustomer.dart';
import '/screens/customerdetail.dart';

class CustomerList extends StatelessWidget{
  final List<Map<String, String>> customers =[
    {
      'name':'Jigar Patel',
      'email': 'pateljigar2505@gmail.com',
      'phone': '+91 95746 92421',
    },
    {
      'name':'Dhruv Patel',
      'email': 'pateldhruv2505@gmail.com',
      'phone': '+91 95746 92421',
    },
    {
      'name':'Meet Solanki',
      'email': 'solankimeet@gmail.com',
      'phone': '+91 95746 92421',
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customers')),
      body: ListView.builder(
        itemCount: customers.length,
        itemBuilder: (context, index){
          final customer = customers[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical:8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                child: Text(customer['name']![0]),
              ),
              title: Text(customer['name']!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(customer['email']!),
                  Text(customer['phone']!),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios,size: 16),
              onTap:(){
                // Navigate to customer detail screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomerDetail(customer: customer),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            //Navigate to add customer screen
            Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddCustomer()),);
          },
        child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Color(0xff5B3DDE)
      ),
    );
  }
}