import 'package:crm/screens/profile/controller.dart';
import 'package:crm/utils/ui_utils.dart';
import 'package:crm/widgets/detailcontainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:crm/theme/colors.dart';
import 'package:crm/widgets/buttons.dart';
import 'package:crm/widgets/detailrow.dart';
import 'package:provider/provider.dart';
import '../../widgets/headcontainer.dart';
import 'updatepassword.dart';
import '../auth/loginscreen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}
class _ProfileState extends State<Profile>{

  @override
  void initState() {
    super.initState();
    Provider.of<ProfileController>(context ,listen: false).loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, controller, _) {
        var user = controller.currentUser;
        if (user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        var name = user.name ?? 'User';
        var email = user.email ?? 'Not Available';
        var phone = user.phoneNo ?? 'Not Available';
        var role = user.role ?? 'User';
        var leads = controller.assignedLeadsCount;
        var deals = controller.assignedDealsCount;
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Profile',
              style: TextStyle(color: Color(0xffffffff)),
            ),
            backgroundColor: kSecondaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile header with avatar
                HeadContainer(
                  title: name,
                  subtitle: role,
                  avatarText: name,
                  showAvatar: true,
                  backgroundColor: Color(0xff1f1453),
                ),
                // Account Information section
                vSpace(),
                DetailContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Account Information:', style: TextStyle(fontSize: 24)),
                      vSpace(12),
                      DetailRow(label: 'Email', value: email),
                      vSpace(12),
                      DetailRow(label: 'Phone', value: phone),
                      vSpace(12),
                      DetailRow(label: 'Number of Leads Assigned', value: leads.toString()),
                      vSpace(12),
                      DetailRow(label: 'Number of Deals Assigned', value: deals.toString()),
                      vSpace(12),
                    ],
                  ),
                ),
                vSpace(),
                // Security section
                DetailContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Security',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                              alignment: Alignment.centerLeft),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UpdatePassword()),
                            );
                          },
                          icon: const Icon(Icons.lock_outline_rounded),
                          label: const Text(
                            'Change Password',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Log Out Button
                vSpace(),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: elevatedButton(
                      label: 'Log Out',
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                vSpace(),
              ],
            ),
          ),
        );
      },
    );
  }
}
