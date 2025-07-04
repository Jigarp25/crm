import 'package:crm/firebase/Model/Deal.dart';
import 'package:crm/screens/deal/controller.dart';
import 'package:crm/utils/ui_utils.dart';
import 'package:crm/widgets/detailcontainer.dart';
import 'package:crm/widgets/headcontainer.dart';
import 'package:flutter/material.dart';
import 'package:crm/widgets/notes.dart';
import 'package:crm/widgets/detailrow.dart';
import 'package:crm/theme/colors.dart';
import 'package:provider/provider.dart';

class DealDetail extends StatefulWidget {
 final DealModel deal;

  const DealDetail({super.key, required this.deal});

  @override
  State<DealDetail> createState() => _DealDetailState();
}
class _DealDetailState extends State<DealDetail>{
  late String selectedStatus;
  String customerName ='Loading...';

  @override
  void initState(){
    super.initState();
    Provider.of<DealController>(context, listen: false).loadDropDownData();
    selectedStatus = widget.deal.status ?? '';
  }

  void _showEditAmountDialog(BuildContext context) {
    TextEditingController controller =
    TextEditingController(text: widget.deal.amount?.toStringAsFixed(2) ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xfffef7ff),
          title: const Text('Edit Amount'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration:  inputDecoration(
              label: 'Amount',
              hint: 'Enter Amount',
              prefixIcon: Icons.currency_rupee_outlined,
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
              onPressed: () async {
                double? newAmount = double.tryParse(controller.text);
                if(newAmount != null){
                  setState(() {
                    widget.deal.amount =newAmount;
                  });
                  var controllerProvider = Provider.of<DealController>(context, listen: false);
                  String? error =await controllerProvider.updateDealAmount(widget.deal.id!, newAmount);
                  if (error == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Amount updated successfully')),
                    );
                  }else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)),
                    );
                  }
                }
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
  Widget build(BuildContext context) {
    var deal = widget.deal;
    var title = deal.title ?? 'Deal Detail';
    var assignedTo = deal.assignedTo ?? 'Not Available';
    var customerId = deal.customerId ?? 'Customer';
    var amount = deal.amount ?? '';
    var description = deal.description ?? '';
    var companyName = deal.companyName ??'';

    var controller = Provider.of<DealController>(context);
    var assignedToName = controller.assignedUserList
        .firstWhere(
          (user) => user['id'] == assignedTo,
      orElse: () => {'name': 'Unknown'},
    )['name'] ??
        'Unknown';

    var customerName = controller.customerList
        .firstWhere(
          (cust) => cust['id'] == customerId,
      orElse: () => {'name': 'Unknown'},
    )['name'] ??
        'Unknown';

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
              subtitle: assignedToName,
            ),
            vSpace(),
            DetailContainer(
              child: Column(
                children: [
                  DetailRow(label: 'Description', value: description),
                   vSpace(12),
                  DetailRow(label: 'Company name', value: companyName),
                   vSpace(12),
                  DetailRow(label: 'Customer', value: customerName),
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
                              DropdownButton(
                                isExpanded: true,
                                value: selectedStatus,
                                onChanged: (value) async{
                                  if(value != null && value != selectedStatus){
                                    setState(() {
                                      selectedStatus = value;
                                    });
                                    var dealId =widget.deal.id;
                                    var error = await controller.updateDealStatus(dealId!, value);
                                    if(error == null){
                                      widget.deal.status = value;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Status updated successfully')),
                                      );
                                    }else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Status updated successfully')),
                                      );
                                    }
                                  }
                                },
                             items: controller.dealStatus
                                 .map((status) =>DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                             )).toList(),
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
          Note(noteKey: 'lead_notes_${widget.deal.id ??'unknown'}'),
           vSpace(32)
          ],
        ),
      ),
    );
  }
}



