import 'package:flutter/material.dart';

class CustomerDetail extends StatelessWidget {
  final Map<String, String> customer;

  const CustomerDetail({super.key, required this.customer});

  static final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final name = customer['name'] ?? 'Customer Detail';
    final email = customer['email'] ?? 'Not Available';
    final phone = customer['phone'] ?? 'Not Available';
    final companyname = customer['companyname'] ?? 'Not Available';
    final address = customer['address'] ?? 'Not Available';

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 345,
                  color: const Color(0xff1F1453),
                ),
                Positioned(
                  top: 20,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Color(0xffeaddff),
                        child: Text(
                          name[0],
                          style: const TextStyle(
                            fontSize: 70,
                            color: Color(0xff4f378b),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.email_outlined, color: Colors.white),
                          const SizedBox(width: 12),
                          Text(
                            email,
                            style:const TextStyle(
                              color: Colors.white,
                              fontSize:18,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.phone_outlined, color: Colors.white),
                          const SizedBox(width: 12),
                          Text(
                            phone,
                            style:const TextStyle(
                                color: Colors.white,
                                fontSize:18,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.apartment_outlined, color: Colors.white),
                          const SizedBox(width: 12),
                          Text(
                            companyname,
                            style:const TextStyle(
                                color: Colors.white,
                                fontSize:18,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton.icon(
                            onPressed: ()  {
                              //TODO: Add Phone call action
                            },
                            icon:const Icon(Icons.call_outlined),
                            label:const Text("call",
                                style: TextStyle(
                                    fontSize: 16
                                )
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xff7B61FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(45),
                              ),
                            ),
                          ),
                          const SizedBox(width:16),
                          ElevatedButton.icon(
                            onPressed: (){
                              //TODO: Add Phone E-mail action
                            },
                            icon:const Icon(Icons.email_outlined),
                            label:const Text("Mail" ,
                              style: TextStyle(
                                fontSize: 16
                              )
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xff7B61FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(45),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: Text(
                'Address',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize:18),
              ),
              subtitle: Text(address,style: const TextStyle(fontSize: 16)
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notes:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Write a note...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}