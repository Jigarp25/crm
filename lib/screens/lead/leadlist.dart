import 'package:crm/screens/lead/controller.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:crm/screens/lead/leaddetails.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/ui_utils.dart';
import '../../widgets/buttons.dart';
import 'addlead.dart';
import '/services/dummydata.dart';

class LeadList extends StatefulWidget{
  const LeadList({super.key});
  @override
  State<LeadList> createState() => _LeadListState();

}

class _LeadListState extends State<LeadList>{
  List<Map<String,String>> _filteredLead = Dummydata.allLeads;
  String? selectedAssignedTO;
  String? selectedStatus;

  Future<void> _openFilterDialog() async {
    String? tempAssignedTo = selectedAssignedTO;
    String? tempStatus = selectedStatus;

    final assignedList = Dummydata.allLeads
        .map((e) => e['assignedTo'])
        .whereType<String>()
        .toSet()
        .toList();

    final statusList = Dummydata.allLeadStatus;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xfffef7ff),
          title: const Text('Filter Leads'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownSearch<String>(
                  items: assignedList,
                  selectedItem: tempAssignedTo ,
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        filled:true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    menuProps: MenuProps(
                        backgroundColor: Colors.white,
                        borderRadius: BorderRadius.circular(16)
                    ),
                  ),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                        labelText: 'Assigned',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16))
                        ),
                        filled: true,
                        fillColor: Color(0xffffffff)
                    ),
                  ),
                  onChanged: (value){
                    tempAssignedTo = value?.toLowerCase();
                  },
                  clearButtonProps: ClearButtonProps(isVisible: true),
                ),
                vSpace(),
                DropdownSearch<String>(
                  items: statusList,
                  selectedItem: tempStatus ,
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        filled:true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    menuProps: MenuProps(
                        backgroundColor: Colors.white,
                        borderRadius: BorderRadius.circular(16)
                    ),
                  ),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                        labelText: 'Status ',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16))
                        ),
                        filled: true,
                        fillColor: Color(0xffffffff)
                    ),
                  ),
                  onChanged: (value){
                    tempStatus = value == 'All' ? null : value?.toLowerCase();
                  },
                  clearButtonProps: const ClearButtonProps(isVisible: true),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffffffff)
              ),
              onPressed: (){
                setState((){
                  selectedAssignedTO = tempAssignedTo;
                  selectedStatus = tempStatus;
                  _applyFilters();
                });
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  void _applyFilters(){
    setState(() {
      _filteredLead = Dummydata.allLeads.where((lead){
        final leadAssignedTo = lead['assignedTo']?.toLowerCase();
        final leadStatus = lead['status']?.toLowerCase();
        final matchAssigned = selectedAssignedTO == null || leadAssignedTo == selectedAssignedTO;
        final matchStatus = selectedStatus == null || leadStatus ==  selectedStatus;
        if(selectedAssignedTO != null &&  selectedStatus != null){
          return matchStatus && matchAssigned;
        }else if(selectedAssignedTO != null){
          return matchAssigned;
        }else if(selectedStatus != null){
          return matchStatus;
        }
        return true;
      }).toList();
    });
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
    final leads = _filteredLead;
    return Scaffold(
      appBar: AppBar(
        title: Text('Lead list'),
        actions: [
          IconButton(onPressed: _openFilterDialog, icon: Icon(Icons.filter_list_outlined)),
          _appSearchAnchor(context),
        ],
      ),
      body: ListView.builder(
        itemCount: leads.length,
        itemBuilder:(context, index){
          final lead =leads[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal:16, vertical:8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation:2,
            child: ListTile(
              title: Text(lead['title']??''),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Company name: ${lead['companyName']}'),
                    Text('Assigned to : ${lead['assignedTo']}'),
                  ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(lead['status']??'').withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  lead['status']?? '',
                  style: TextStyle(color: Color(0xff000000),
                  fontSize: 11),
                ),
              ),
              onTap: () {
                // Navigate to lead detail
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LeadDetail(lead : lead),
                    ),
                );
              },
            )
          );
        },
      ),
      floatingActionButton: floatingButton(
       onPressed:() async {
        // Navigate to lead add screen
         Navigator.push(context,
           MaterialPageRoute(
               builder: (context) => ChangeNotifierProvider(
                   create:(_) => LeadController()
                    ..setCustomerList(Dummydata.allCustomers.map((c)=> c['name'] ?? '').toList())
                    ..setAssignedUserList(Dummydata.allUser.map((u)=> u['name'] ?? '').toList()),
                   child: const AddLead(),
               )
           ),
         );
      },
    icon: Icons.add,
      ),
    );
  }

  Widget _appSearchAnchor(BuildContext context) {
    return SearchAnchor(
      builder: ( context,controller) {
        return IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => controller.openView(),
        );
      },
      suggestionsBuilder:
          (BuildContext context, SearchController controller) async {
        final query = controller.text.toLowerCase();
        await Future.delayed(Duration(milliseconds: 300));

        if (query.isEmpty) return [];

        final leadResults = Dummydata.allLeads.where((lead) {
          final title = lead['title']?.toLowerCase() ?? '';
          final assignedTo = lead['assignedTo']?.toLowerCase() ?? '';
          final customer = lead['customer']?.toLowerCase() ?? '';
          return title.contains(query) ||
              assignedTo.contains(query) ||
              customer.contains(query);
        }).toList();

        final options = <Widget>[
          ...leadResults.map((lead) {
            final title = lead['title'] ?? '';
            final assignedTo = lead['assignedTo'] ?? '';
            final customer = lead['customer'] ?? '';
            String subtitleText = '';

            if (customer.toLowerCase().contains(query)) {
              subtitleText = 'Customer : $customer';
            } else if (assignedTo.toLowerCase().contains(query)) {
              subtitleText = 'Assigned: $assignedTo';
            }

            return ListTile(
              title: Text(title),
              subtitle: Text(subtitleText),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LeadDetail(lead: lead),
                  ),
                );
              },
            );
          }),
        ];
        return options;
      },
    );
  }
}