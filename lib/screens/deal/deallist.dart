import 'package:crm/screens/deal/controller.dart';
import 'package:crm/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../firebase/Model/Deal.dart';
import '../../utils/filterdialog.dart';
import 'dealdetail.dart';

class DealList extends StatefulWidget {
  const DealList({super.key});

  @override
  State<DealList> createState() => _DealListState();
}

class _DealListState extends State<DealList> {
  late DealController _dealController;
  List<DealModel> _filteredDeals = [];

  @override
  void initState() {
    super.initState();
    _dealController = Provider.of<DealController>(context, listen: false);

    _dealController = Provider.of<DealController>(context, listen: false);
    _dealController.loadDropdownCustomerData().then((_) {
      _dealController.loadDropdownAssignData().then((_){
        _dealController.loadCurrentUser();
      });
    });
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _dealController = Provider.of<DealController>(context,listen: false);
    _dealController.loadDeals();
  }

  String? selectedAssignedTo;
  String? selectedStatus;

  Future<void> _openFilterDialog() async {
    final result = await showFilterDialog(
      context: context,
      statusList: _dealController.dealStatus,
      currentAssignedId: selectedAssignedTo,
      currentStatus: selectedStatus,
      assignedUserList: _dealController.assignedUserList,
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

      await _dealController.applyDealFilters(assignedTo: selectedAssignedTo,status: selectedStatus,);
    }
  }


  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'proposal sent':
        return Colors.orange;
      case 'negotiation':
        return Colors.blueAccent;
      case 'contract sent':
        return Colors.purple;
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
    return Consumer<DealController>(
      builder: (context, controller, _) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        _filteredDeals = controller.deals;

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
              var deal = _filteredDeals[index];
              var isAdmin = controller.currentUser?.role?.toLowerCase() == 'admin';
              return GestureDetector(
                  onLongPress: isAdmin
                      ? () async{
                    var confirm =await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete Deal from ${deal.companyName}'),
                        content: const Text('Are you sure you want to delete lead ? This action cannot Be Undone.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
                          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text('Delete',style: TextStyle(color: Colors.red),)),
                        ],
                      ),
                    );
                    if(confirm == true){
                      await controller.removeDeal(deal.id!);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('deal deleted')));
                    }
                  }
                  :null,
                child:  Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: ListTile(
                    title: Text(deal.title ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Assigned To: ${controller.assignedUserList.firstWhere(
                                (user) => user['id'] == deal.assignedTo,
                            orElse: () {
                                  debugPrint(' No match found for: ${deal.assignedTo}');
                                  return {'name': 'Unknown'};
                                  },
                          )['name']}',
                        ),
                        Text(
                          'Customer Name: ${controller.customerList.firstWhere(
                              (customer) => customer['id'] == deal.customerId,
                          orElse: () {
                            debugPrint(' No match found for: ${deal.customerId}');
                            return {'name': 'Unknown'};
                          },
                        )['name']}',
                        ),
                        Text('Amount: ₹${deal.amount?.toStringAsFixed(2) ?? '0'}'),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(deal.status ?? '').withAlpha(80),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        deal.status ?? '',
                        style: const TextStyle(color: Colors.black, fontSize: 11),
                      ),
                    ),
                    onTap: ()  async{
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DealDetail(deal: deal),
                        ),
                      );
                      Provider.of<DealController>(context,listen: false).loadDeals();
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _appSearchAnchor(BuildContext context) {
    return SharedSearch(data: _dealController.getDealSearchList(), onSelect: (dealMap){
      var title = dealMap['title'];
      var match = _dealController.deals.firstWhere(
          (d) => d.title == title,
        orElse: () => DealModel()
      );

      if(match.id != null){
        Navigator.push(context,
          MaterialPageRoute(
            builder: (_) => DealDetail(deal: match),
          ),
        );
      }else{
        debugPrint('Deal not found for title: $title');
      }
    },
    );
  }

}