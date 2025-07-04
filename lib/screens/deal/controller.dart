import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../firebase/Apis.dart';
import '../../firebase/Model/Deal.dart';
import '../../firebase/Model/Lead.dart';
import '../../firebase/Model/User.dart';

class DealController with ChangeNotifier{
  var formKey = GlobalKey<FormState>();
  var txtAmount = TextEditingController();

  String? selectedAssignedTo;
  String? selectedStatus;

  List<DealModel> deals =[];
  List<DealModel> filteredDeals =[];

  bool isLoading = false;
  bool isDropdownLoading = false;

  List<Map<String, String>> customerList = [];
  List<Map<String, String>> assignedUserList = [];

  UserModel? currentUser;

  Future<void> loadCurrentUser() async {
    try {
      currentUser = await API.getCurrentUser();
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load current user: $e');
    }
  }

  Future<void> loadDropdownAssignData() async {
    try {
      isDropdownLoading = true;
      notifyListeners();

      var usersMap = await API.getAllUserNames();
      assignedUserList = usersMap.map((userMap) => {
        'id': (userMap["id"] ?? '').toString(),
        'name': (userMap["name"] ?? '').toString(),
      }).toList();

      isDropdownLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading assigned users: $e');
    }
  }

  /// Fetch customers for dropdown
  Future<void> loadDropdownCustomerData() async {
    try {
      isDropdownLoading = true;
      notifyListeners();

      var customerMap = await API.getAllCustomerNames();
      customerList = customerMap.map((c) => {
        'id': (c["id"] ?? '').toString(),
        'name': (c["name"] ?? '').toString(),
      }).toList();

      isDropdownLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading customers: $e');
    }
  }

  Future<String?> updateDealAmount(String dealId, double newAmount) async {
    try {
      await API.updateDealAmount(dealId, newAmount);
      notifyListeners();
      return null;
    } catch (e) {
      debugPrint("Failed to update deal amount: $e");
      return "Failed to update amount";
    }
  }

  Future<String?> updateDealStatus(String dealId, String newStatus) async {
    try {

      await API.updateDealStatus(dealId, newStatus);

      if (newStatus.toLowerCase() == 'won' || newStatus.toLowerCase() == 'lost') {
        await API.updateDealCloseDate(dealId, {
          'closedDate': Timestamp.now()
        });
      } else {
        await API.updateDealCloseDate(dealId, {
          'closedDate': null
        });
      }

      for (var deals in deals){
        if (deals.id == dealId){
          deals.status = newStatus;
          break;
        }
      }

      notifyListeners();
      return null;
    } catch (e) {
      debugPrint('Status update failed: $e');
    }
    return null;
  }

  List<String> dealStatus = [
    'Proposal Sent',
    'Negotiation',
    'Contract Sent',
    'Won',
    'Lost',
   ];

  void loadDropDownData(){
    loadDropdownAssignData();
    loadDropdownCustomerData();
  }

   bool validateForm(){
     return formKey.currentState?.validate() ?? false ;
   }

   void setStatus(String? status){
     selectedStatus = status;
     notifyListeners();
   }

   void clearDeal(){
     txtAmount.clear();
     selectedStatus = null;
     notifyListeners();
   }

  void initFromLead(LeadModel lead) {
    DealModel(
      title: lead.title,
      description: lead.description,
      companyName: lead.companyName,
      assignedTo: lead.assignedTo,
      customerId: lead.customerId,
      createdAt: Timestamp.now(),
    );
  }

  Future<void> removeDeal(String id) async{
    try{
      await API.removeCustomer(id);
      deals.removeWhere((d) => d.id == id);
      notifyListeners();
    } catch(e){
      debugPrint('Delete Customer Error: $e');
    }
  }

  Future<String?> submitDeal({required LeadModel lead}) async {
    if (!formKey.currentState!.validate()) return 'Invalid form';

    var amount = double.tryParse(txtAmount.text.trim());
    if (amount == null) return 'Invalid amount';

    var deal = DealModel(
      leadId: lead.id ?? '',
      assignedTo: lead.assignedTo ?? '',
      title: lead.title ?? '',
      description: lead.description ?? '',
      amount: amount,
      status: selectedStatus ?? '',
      companyName: lead.companyName ?? '',
      customerId: lead.customerId ?? '',
      createdAt: Timestamp.fromDate(DateTime.now()),
    );

    try {
      var id = await API.addDeal(deal );
      debugPrint('Deal added with ID: $id');
      
       if (lead.id != null){
       await API.removeLead(lead.id!);
       debugPrint('Lead converted');
       return null;
       }
    } catch (e) {
      debugPrint(' Error submitting deal: $e');
      return 'Failed to add deal: $e';
    }
    return null;
  }

  Future<void> applyDealFilters({String? assignedTo,String? status})async {
    try{
      isLoading = true;
      notifyListeners();

      deals =await API.getFilteredDeals(assignedTo: assignedTo,status: status);
    }catch(e){
      debugPrint('Error filtering delas: $e');
    }finally{
      isLoading =false;
      notifyListeners();
    }
  }

  List<Map<String, String>> getDealSearchList() {
    return deals.map((deal) {
      final title = deal.title ?? '';
      final assignedTo = assignedUserList
          .firstWhere((u) => u['id'] == deal.assignedTo, orElse: () => {'name': 'Unknown'})['name']!;
      final customer = customerList
          .firstWhere((c) => c['id'] == deal.customerId, orElse: () => {'name': 'Unknown'})['name']!;
      return {
        'title': title,
        'assignedTo': assignedTo,
        'customer': customer,
      };
    }).toList();
  }


  Future<void> loadDeals() async {
    try {
      isLoading = true;
      notifyListeners();

      deals = await API.getAllDeal();

      debugPrint('Total deals: ${deals.length}');
    } catch (e) {
      debugPrint('Error fetching deals: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}
