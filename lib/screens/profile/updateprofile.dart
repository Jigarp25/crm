import 'package:crm/screens/profile/controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/ui_utils.dart';

class UpdateProfile extends StatefulWidget{
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() =>_UpdateProfileState();
}
class _UpdateProfileState extends State<UpdateProfile>{
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var controller = Provider.of<ProfileController>(context, listen: false);
      var user = controller.currentUser;

      controller.txtname.text = user?.name ?? '';
      controller.txtemail.text = user?.email ?? '';
    });
  }
  @override
  void dispose() {
    Provider.of<ProfileController>(context,listen: false).clearFields();
    super.dispose();
  }

  void _saveProfile() async {
     // var controller = Provider.of<ProfileController>(context, listen: false);
     // var result = await controller.updateProfile();
     //
     // if (!mounted) return;
     // if (result == null){
     //   ScaffoldMessenger.of(context).showSnackBar(
     //    const SnackBar(content: Text('Profile Updated Successfully')),
     //   );
     //   dispose();
     //   Navigator.pop(context);
     // }else {
     //    ScaffoldMessenger.of(context).showSnackBar(
     //      SnackBar(content: Text(result)),
     //    );
     //  }
   }


  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<ProfileController>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Update Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Name',style: TextStyle(fontSize: 18),),
            TextField(
              controller: controller.txtname,
              decoration: inputDecoration(hint: 'Enter Name'),
            ),
            vSpace(),
            const Text('E-mail',style: TextStyle(fontSize: 18),),
            TextField(
              controller: controller.txtemail,
              decoration: inputDecoration(hint: 'Enter E-mail'),
            ),
            vSpace(),
            const Text('Password',style: TextStyle(fontSize: 18),),
            TextField(
              controller: controller.txtProfilePassword,
              decoration: inputDecoration(hint: 'Enter Password'),
            ),
            vSpace(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff5b3dde),
                  ),
                  child: const Text('Save',
                      style: TextStyle(color:Color(0xffffffff),fontSize:18 )
                  ),
              ),
            )
          ],
        )
      ),
    );
  }
}
