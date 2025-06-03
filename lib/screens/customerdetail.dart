import 'package:flutter/material.dart';

class CustomerDetail  extends StatelessWidget{
  final Map<String, String> customer;

  const CustomerDetail({super.key, required this.customer});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text(customer['name'] ?? 'customer Detail')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 400,
                  color: const Color(0xff1F1453),
                ),
                Positioned(
                  top: 50,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      customer ['name']![0],
                      style: const TextStyle(
                        fontSize: 70,
                        color: Color(0xff5BB3DDE),
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],//children
        )
      ),
    );
  }
}