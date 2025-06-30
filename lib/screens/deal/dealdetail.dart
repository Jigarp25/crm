import 'package:crm/utils/ui_utils.dart';
import 'package:crm/widgets/detailcontainer.dart';
import 'package:crm/widgets/headcontainer.dart';
import 'package:flutter/material.dart';
import 'package:crm/widgets/notes.dart';
import 'package:crm/widgets/detailrow.dart';
import 'package:crm/theme/colors.dart';

class DealDetail extends StatefulWidget {
  final Map<String, String> deal;

  const DealDetail({super.key, required this.deal});

  @override
  State<DealDetail> createState() => _DealDetailState();
}
class _DealDetailState extends State<DealDetail>{
  late String selectedStatus;

  final List<String> dealStatuses = [
    'Proposal Sent',
    'Negotiation',
    'Contract Sent',
    'Won',
    'Lost',
    'onHold',
    'NoResponse'
  ];

  void _showEditAmountDialog(BuildContext context) {
    final TextEditingController controller =
    TextEditingController(text: widget.deal['amount'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xfffef7ff),
          title: const Text('Edit Amount'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.currency_rupee_outlined),
              border:OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
              )
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  widget.deal['amount'] = controller.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }


  @override
  void initState(){
    super.initState();
    selectedStatus=widget.deal['status']??'';
  }

  @override
  Widget build(BuildContext context) {
    final deal = widget.deal;
    final title = deal['title'] ?? 'Deal Detail';
    final assignedto = deal['assignedTo'] ?? 'Not Available';
    final customer = deal['customer'] ?? 'Customer';
    final amount = deal['amount'] ?? '';
    final description = deal['description'] ?? '';
    final companyname = deal['companyname'] ??'';

    return Scaffold(
      appBar: AppBar(
        title: Text('Deal Detail',style: TextStyle(color: Color(0xffffffff)),),
        backgroundColor: kSecondaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadContainer(
              title: title,
              subtitle: assignedto,
            ),
            vSpace(),
            DetailContainer(
              child: Column(
                children: [
                  DetailRow(label: 'Description', value: description),
                   vSpace(12),
                  DetailRow(label: 'Company name', value: companyname),
                   vSpace(12),
                  DetailRow(label: 'Customer', value: customer),
                   vSpace(12),
                ],
              ) ,
            ),
            vSpace(),
            DetailContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.flag_outlined, color:Colors.deepPurple, size: 28),
                      hSpace(16),
                      Expanded(
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Status',
                                  style: TextStyle(fontSize: 14,color: Color(0xff000000)),
                              ),
                              DropdownButton<String>(
                                isExpanded: true,
                                value: selectedStatus,
                                onChanged: (value){
                                  if(value != null){
                                    setState(() {
                                      selectedStatus = value;
                                    });
                                  }
                                },
                              items: dealStatuses.map((status){
                                return DropdownMenuItem(
                                  value: status,
                                  child: Text(status, style: const TextStyle(fontSize: 16)),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  vSpace(8),
                  DetailRow(
                  label: 'Amount',
                  value: '₹ $amount',
                  trailingIcon: Icons.edit_outlined,
                  iconBgColor: Colors.white,
                  trailingIconColor: Color(0xff5d3dde),
                  onTap: (){
                    _showEditAmountDialog(context);
                    // edit mechanism
                  },
                ),
              ],
            ),
          ),
          vSpace(),
          Note(noteKey: 'lead_notes_${widget.deal['id']??'unknown'}'),
           vSpace(32)
          ],
        ),
      ),
    );
  }
}



