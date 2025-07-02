import 'package:crm/theme/colors.dart';
import 'package:crm/utils/ui_utils.dart';
import 'package:crm/widgets/detailcontainer.dart';
import 'package:flutter/material.dart';
import 'package:crm/utils/communication.dart';
import 'package:crm/widgets/notes.dart';
import 'package:crm/widgets/detailrow.dart';
import 'package:provider/provider.dart';
import '../../firebase/Model/Customer.dart';
import '../../widgets/headcontainer.dart';
import 'controller.dart';

class CustomerDetail extends StatefulWidget {
  final CustomerModel customer;

  const CustomerDetail({super.key, required this.customer});

  @override
  State<CustomerDetail> createState() => _CustomerDetailState();
}

class _CustomerDetailState extends State<CustomerDetail> {
  @override
  Widget build(BuildContext context) {
    var customer = widget.customer;
    var name = customer.name ?? 'Customer Detail';
    var email = customer.email ?? 'Not Available';
    var phone = customer.phoneNo ?? 'Not Available';
    var companyname = customer.companyName ?? 'Not Available';
    var createdById = customer.createdBy ?? '';
    var controller = Provider.of<CustomerController>(context);
    var createdByName = controller.userIdToNameMap[createdById] ?? 'Unknown';


    var address = [
      customer.buildingName,
      customer.area,
      customer.city,
      customer.state,
      customer.pincode?.toString(),
    ].where((e) => e != null && e.toString().isNotEmpty).join(', ');

    return Scaffold(
      appBar: AppBar(
        title: Text(name, style: const TextStyle(color: Color(0xffffffff))),
        backgroundColor: kSecondaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeadContainer(
              title: name,
              subtitle: companyname,
              avatarText: name,
              showAvatar: true,
              backgroundColor: const Color(0xff1f1453),
            ),
            vSpace(),
            DetailContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailRow(
                    label: 'email',
                    value: email,
                    trailingIcon: Icons.mail_outline,
                    iconBgColor: const Color(0xff3b82f6),
                    onTap: () => Communication.sendEmail(context, email),
                  ),
                  vSpace(12),
                  DetailRow(
                    label: 'phone',
                    value: phone,
                    trailingIcon: Icons.phone_outlined,
                    iconBgColor: const Color(0xff10b981),
                    onTap: () => Communication.makePhoneCall(context, phone),
                  ),
                  vSpace(12),
                  DetailRow(label: 'Address', value: address),
                  vSpace(12),
                  DetailRow(label: 'Created By', value: createdByName),
                ],
              ),
            ),
            vSpace(),
            Note(noteKey: 'customer_notes_${customer.id ?? 'unknown'}'),
          ],
        ),
      ),
    );
  }
}
