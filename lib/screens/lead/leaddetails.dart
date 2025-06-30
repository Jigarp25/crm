import 'package:crm/screens/deal/adddeal.dart';
import 'package:crm/utils/ui_utils.dart';
import 'package:crm/widgets/detailcontainer.dart';
import 'package:flutter/material.dart';
import 'package:crm/utils/communication.dart';
import 'package:crm/widgets/notes.dart';
import 'package:crm/widgets/detailrow.dart';
import '../../widgets/buttons.dart';
import '../../widgets/headcontainer.dart';

class LeadDetail extends StatefulWidget {
  final Map<String, String> lead;

  const LeadDetail({super.key, required this.lead});

  @override
  State<LeadDetail> createState() => _LeadDetailState();
}

class _LeadDetailState extends State<LeadDetail>{
  late String selectedStatus;

  final List<String> leadStatuses = [
    'New',
    'Contacted',
    'Qualified',
    'Unqualified',
    'Converted',
    'Unconverted'
  ];

  @override
  void initState(){
    super.initState();
    selectedStatus=widget.lead['status']??'';
  }

  @override
  Widget build(BuildContext context) {
    final lead = widget.lead;
    final title = lead['title'] ?? 'Lead Detail';
    final assignedto = lead['assignedTo'] ?? 'Not Available';
    final companyname = lead['companyName']?? 'Not Available';
    final phone = lead['phone']?? 'Not Available';
    final email = lead['email']?? 'Not Available';
    final customer = lead['customer']?? 'Not Available';
    final description = lead['description']?? 'Not Available';

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
              subtitle: assignedto,
            ),
            vSpace(),
            DetailContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailRow(label: 'Description', value: description),
                  vSpace(12),
                  DetailRow(label: 'Company Name', value: companyname),
                  vSpace(12),
                  DetailRow(label: 'Customer', value: customer),
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
                            onChanged: (value){
                              if(value != null){
                                setState(() {
                                  selectedStatus=value;
                                });
                              }
                            },
                            items: leadStatuses.map((status){
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
            Note(noteKey: 'lead_notes_${widget.lead['id']??'unknown'}'),
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

