import 'package:crm/screens/deal/adddeal.dart';
import 'package:crm/screens/lead/controller.dart';
import 'package:crm/utils/ui_utils.dart';
import 'package:crm/widgets/detailcontainer.dart';
import 'package:flutter/material.dart';
import 'package:crm/utils/communication.dart';
import 'package:crm/widgets/notes.dart';
import 'package:crm/widgets/detailrow.dart';
import 'package:provider/provider.dart';
import '../../widgets/buttons.dart';
import '../../widgets/headcontainer.dart';
import '../../firebase/Model/Lead.dart';

class LeadDetail extends StatefulWidget {
  final LeadModel lead;

  const LeadDetail({super.key, required this.lead});

  @override
  State<LeadDetail> createState() => _LeadDetailState();
}

class _LeadDetailState extends State<LeadDetail>{
  late String selectedStatus;
  String customerName ='Loading...';


  @override
  void initState(){
    super.initState();
    Provider.of<LeadController>(context, listen: false).loadDropDownData();
    selectedStatus = widget.lead.status ?? '';
  }

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<LeadController>(context, listen: false);
    var lead = widget.lead;
    var title = lead.title ?? 'Lead Detail';
    var companyName = lead.companyName ?? 'Not Available';
    var phone = lead.phoneNo ?? 'Not Available';
    var email = lead.email ?? 'Not Available';
    var description = lead.description ?? 'Not Available';

    var assignedTo = controller.assignedUserList.firstWhere(
        (u) => u['id'] == lead.assignedTo,
      orElse: (){
        if (controller.customerList.isEmpty) {
          debugPrint('️ Customer list is still empty');
        }
        debugPrint('No assigned user found for ID: ${lead.assignedTo}');
          return{'name':'unknown'};

      },
    );
    var assignedName = assignedTo['name']?? 'Unknown';
    var customerName = 'Loading...';
    if (controller.customerList.isNotEmpty) {
      var matchedCustomer = controller.customerList.firstWhere(
            (c) => c['id'] == lead.customerId,
        orElse: () {
          debugPrint('No customer found for ID: ${lead.customerId}');
          return {'name': 'Unknown'};
        },
      );
      customerName = matchedCustomer['name'] ?? 'Unknown';
      debugPrint('Customer name resolved: $customerName');
    } else {
      debugPrint(' Customer list is still empty');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Lead Details', style: TextStyle(color: Color(0xffffffff)),),
        backgroundColor: Color(0xff1f1453),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeadContainer(
              title: title,
              subtitle: assignedName,
            ),
            vSpace(),
            DetailContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailRow(label: 'Description', value: description),
                  vSpace(12),
                  DetailRow(label: 'Company Name', value: companyName),
                  vSpace(12),
                  DetailRow(label: 'Customer', value: customerName),
                  vSpace(12),
                  DetailRow(
                    label: 'Phone',
                    value: phone,
                    trailingIcon: Icons.phone_outlined,
                    iconBgColor: const Color(0xff10b981),
                    onTap: () => Communication.makePhoneCall(context, phone),
                  ),
                  vSpace(12),
                  DetailRow(
                    label: 'Email',
                    value: email,
                    trailingIcon: Icons.email_outlined,
                    iconBgColor: const Color(0xff3b82f6),
                    onTap: () => Communication.sendEmail(context, email),
                  ),
                ],
              ),
            ),
            vSpace(),
            DetailContainer(
              child:
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.flag_outlined, color: Colors.deepPurple,size: 28),
                  hSpace(),
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Status',
                            style: TextStyle(fontSize: 14,color: Color(0xff000000)),
                          ),
                          DropdownButton(
                            isExpanded: true,
                            value: selectedStatus,
                            onChanged: (value) async {
                              if(value != null && value != selectedStatus){
                                setState(() {
                                  selectedStatus=value;
                                });
                                var leadId =widget.lead.id;
                                var error = await controller.updateLeadStatus(leadId!, value);
                                if(error == null) {
                                  widget.lead.status = value;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Status update successfully')),
                                  );
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Failed to update status'))
                                  );
                                }
                              }
                            },
                            items: controller.leadStatusOptions.map((status){
                              return DropdownMenuItem(
                                value: status,
                                child: Text(
                                    status
                                ),
                              );
                            }).toList(),
                          )
                        ],
                      )
                  ),
                ],
              ),
            ),
            vSpace(),
            Note(noteKey: 'lead_notes_${widget.lead.id??'unknown'}'),
            vSpace(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: elevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddDeal(lead: widget.lead),
                      ),
                    );
                  },
                  label: 'Convert to Deal',
                ),
              ),
            ),
            vSpace()
          ],
        ),
      ),
    );
  }
}

