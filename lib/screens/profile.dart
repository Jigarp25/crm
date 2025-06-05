import 'package:flutter/material.dart';

class Profile extends StatelessWidget{
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    const String name = 'Jigar Patel';
    const String email = 'pateljigar2505@gmail.com';
    const String role = 'Admin';

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
                  height: 160,
                  color: const Color(0xff1f1453),
                ),
                Positioned(
                  top: 30,
                  left:30,
                  right:30,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xffeaddff),
                        child:Text(
                         name[0],
                         style: const TextStyle(
                           fontSize: 50,
                           color: Color(0xff4f378b)
                         ),
                        )
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xffffffff),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                role,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xffffffff),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300
                                ),
                              )
                            ],
                          )
                      )
                    ],
                  )
                )
              ],
            ),
            ListTile(
              leading: const Icon(Icons.mail_outline_rounded),
              title:Text(
                'E-mail',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                email,
              ),
            ),
            Card(color: Color(0xff7d56f8))
          ],
        ),
      ),
    );
  }
}