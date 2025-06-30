import 'package:crm/utils/ui_utils.dart';
import 'package:flutter/material.dart';
//import 'package:filter_list/filter_list.dart';
import '/services/dummydata.dart';
import 'dealdetail.dart';
import 'package:dropdown_search/dropdown_search.dart';

class DealList extends StatefulWidget {
  const DealList({super.key});

  @override
  State<DealList> createState() => _DealListState();
}

class _DealListState extends State<DealList> {
  List<Map<String, String>> _filteredDeals = Dummydata.allDeals;
  String? selectedAssignedTo;
  String? selectedStatus;

  Future<void> _openFilterDialog() async {
    String? tempAssignedTo = selectedAssignedTo;
    String? tempStatus = selectedStatus;

    final assignedList = Dummydata.allDeals
        .map((e) => e['assignedTo'])
        .whereType<String>()
        .toSet()
        .toList();
    
    final statusList = Dummydata.allDealStatus;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xfffef7ff),
          title: const Text('Filter Deals'),
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
                    tempStatus = value == 'All' ? null : value;
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
                backgroundColor: Color(0xff5b3dde),
              ),
              onPressed: (){
                setState((){
                  selectedAssignedTo = tempAssignedTo;
                  selectedStatus = tempStatus;
                  _applyFilters();
                });
                Navigator.pop(context);
              },
              child: const Text('Apply',style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }


  void _applyFilters(){
    setState(() {
      _filteredDeals = Dummydata.allDeals.where((deal){
        final dealAssignedTo = deal['assignedTo']?.toLowerCase();
        final dealStatus = deal['status']?.toLowerCase();
        final matchAssigned = selectedAssignedTo == null || dealAssignedTo == selectedAssignedTo?.toLowerCase();
        final matchStatus = selectedStatus == null || dealStatus ==  selectedStatus?.toLowerCase();
        if(selectedAssignedTo != null &&  selectedStatus != null){
          return matchStatus && matchAssigned;
        }else if(selectedAssignedTo != null){
          return matchAssigned;
        }else if(selectedStatus != null){
          return matchStatus;
        }
          return true;
      }).toList();
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'won':
        return Colors.green;
      case 'lost':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deal List'),
        actions: [
          IconButton(onPressed: _openFilterDialog, icon: Icon(Icons.filter_list)),
          _appSearchAnchor(context),
        ],
      ),
      body: ListView.builder(
        itemCount: _filteredDeals.length,
        itemBuilder: (context, index) {
          final deal = _filteredDeals[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: ListTile(
              title: Text(deal['title'] ?? ''),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Assigned to: ${deal['assignedTo']}'),
                  Text('Customer: ${deal['customer']}'),
                  Text('Amount: ₹${deal['amount']}'),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(deal['status'] ?? '').withAlpha(80),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  deal['status'] ?? '',
                  style: const TextStyle(color: Colors.black, fontSize: 11),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DealDetail(deal: deal),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _appSearchAnchor(BuildContext context) {
    return SearchAnchor(
      builder: (context, controller) {
        return IconButton(
          onPressed: () => controller.openView(),
          icon: const Icon(Icons.search),
        );
      },
      suggestionsBuilder: (context, controller) async {
        final query = controller.text.toLowerCase();
        await Future.delayed(const Duration(milliseconds: 300));

        if (query.isEmpty) return [];

        final dealResult = Dummydata.allDeals.where((deal) {
          final title = deal['title']?.toLowerCase() ?? '';
          final assignedTo = deal['assignedTo']?.toLowerCase() ?? '';
          final customer = deal['customer']?.toLowerCase() ?? '';
          return title.contains(query) ||
              assignedTo.contains(query) ||
              customer.contains(query);
        }).toList();

        final options = <Widget>[
          ...dealResult.map((deal){
            final title = deal['title'] ?? '';
            final assignedTo = deal['assignedTo'] ?? '';
            final customer = deal['customer'] ?? '';
            String subtitleText = '';

            if (customer.toLowerCase().contains(query)){
              subtitleText = 'Customer: $customer';
            } else if(assignedTo.toLowerCase().contains(query)){
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
                      builder: (_) => DealDetail(deal: deal)
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