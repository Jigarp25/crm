import 'package:crm/firebase/Model/Lead.dart';
import 'package:crm/screens/lead/controller.dart';
import 'package:crm/screens/lead/leaddetails.dart';
import 'package:crm/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/filterdialog.dart';
import '../../widgets/buttons.dart';
import 'addlead.dart';

class LeadList extends StatefulWidget{
  const LeadList({super.key});
  @override
  State<LeadList> createState() => _LeadListState();

}

class _LeadListState extends State<LeadList>{
  late LeadController controller;

  String? selectedAssignedTo;
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<LeadController>(context, listen: false);
    
    controller.loadDropdownCustomerData().then((_) {
      controller.loadDropdownAssignData().then((_) {
        controller.loadCurrentUser().then((_) {
          controller.loadLeads();
        });
      });
    });
  }

  Future<void> _openFilterDialog() async {
    final result = await showFilterDialog(
      context: context,
      statusList: controller.leadStatusOptions,
      currentAssignedId: selectedAssignedTo,
      currentStatus: selectedStatus,
      assignedUserList: controller.assignedUserList,
    );

    String? assignedTo = result['assignedTo'];
    String? status = result['status'];

    assignedTo = (assignedTo != null && assignedTo.trim().isEmpty) ? null : assignedTo;
    status = (status != null && status.trim().isEmpty) ? null : status;

    if (assignedTo != selectedAssignedTo || status != selectedStatus) {
      setState(() {
        selectedAssignedTo = assignedTo;
        selectedStatus = status;
      });

      await controller.applyLeadFilters(
        assignedTo: selectedAssignedTo,
        status: selectedStatus,
      );
    }
  }



  Color _getStatusColor(String status){
    switch (status.toLowerCase()){
      case 'new':
        return Colors.blue;
      case 'contacted':
        return Colors.orange;
      case 'qualified':
        return Colors.green;
      case 'unqualified':
        return Colors.red;
      case 'converted':
        return Colors.purple;
      case 'unconverted':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lead list'),
        actions: [
          IconButton(onPressed: _openFilterDialog, icon: Icon(Icons.filter_list_outlined),),
          _appSearchAnchor(context),
        ],
      ),
      body: Consumer<LeadController>(
        builder: (context, controller, _) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          var leads = controller.leads;
          if (leads.isEmpty) {
            return const Center(child: Text('No leads found'));
          }

          return ListView.builder(
            itemCount: leads.length,
            itemBuilder: (context, index) {
              final lead = leads[index];
              var isAdmin = controller.currentUser?.role?.toLowerCase() == 'admin';
              return GestureDetector(
                  onLongPress: isAdmin
                      ? () async{
                    var confirm =await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete Lead from ${lead.companyName}'),
                        content: Text('Are you sure you want to delete lead ? This action cannot Be Undone.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
                          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text('Delete',style: TextStyle(color: Colors.red),)),
                        ],
                      ),
                    );
                    if(confirm == true){
                      await controller.removeLead(lead.id!);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Customer deleted')));
                    }
                  }
                  :null,
                child:  Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: ListTile(
                    title: Text(lead.title ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Company name: ${lead.companyName ?? 'N/A'}'),
                        Text(
                          'Assigned To: ${controller.assignedUserList.firstWhere(
                                    (user) => user['id'] == lead.assignedTo,
                                orElse: () {
                                  debugPrint(' No match found for: ${lead.assignedTo}');
                                  return {'name': 'Unknown'};
                                },
                              )['name']}',
                        ),
                        Text(
                          'Customer Name: ${controller.customerList.firstWhere(
                            (customer) => customer['id'] == lead.customerId,
                              orElse: () {
                                debugPrint(' No match found for: ${lead.customerId}');
                                return {'name': 'Unknown'};
                              },
                          )['name']}',
                        ),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(lead.status??'').withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        lead.status ?? 'Status',
                        style: const TextStyle(
                          color: Color(0xff000000),
                          fontSize: 11,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeadDetail(lead: lead),
                        ),
                      );
                      Provider.of<LeadController>(context,listen: false).loadLeads();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: floatingButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (_) => LeadController()..loadDropDownData(),
                child: const AddLead(),
              ),
            ),
          );
        },
        icon: Icons.add,
      ),
    );
  }


  Widget _appSearchAnchor(BuildContext context) {
    return Consumer<LeadController>(
      builder: (context, controller, _) {
        if (controller.leads.isEmpty || controller.customerList.isEmpty || controller.assignedUserList.isEmpty) {
          return const SizedBox(); // or a disabled icon
        }

        return SharedSearch(
          data: controller.getleadSearchList(),
          onSelect: (leadMap) {
            var title = leadMap['title'];
            var match = controller.leads.firstWhere(
                  (l) => l.title == title,
              orElse: () => LeadModel(),
            );

            if (match.id != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LeadDetail(lead: match)),
              );
            } else {
              debugPrint('Lead not found for title: $title');
            }
          },
        );
      },
    );
  }

}