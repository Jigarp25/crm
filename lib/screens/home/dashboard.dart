import 'package:flutter/material.dart';
import '../customer/customerdetail.dart';
import '../lead/leaddetails.dart';
import '../deal/dealdetail.dart';
import '/services/dummydata.dart';

class Dashboard extends StatelessWidget{
  const Dashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
     //     _AppSearchAnchor(context),
        ],
      ),
        body: SingleChildScrollView(
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.symmetric(horizontal: 16),
                  color: const Color(0xff123456),
                  child: Text('Dashboard Screen',style: TextStyle(color: Colors.white),)
              )
            ],
          ),
        )
    );
  }

  /*Widget _AppSearchAnchor(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
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

        final customerResults = Dummydata.allCustomers.where((customer) =>
            customer['name']!.toLowerCase().contains(query)).toList();

        final leadResults = Dummydata.allLeads.where((lead) =>
            lead['title']!.toLowerCase().contains(query)).toList();

        final dealResult = Dummydata.allDeals.where((deal) =>
            deal['title']!.toLowerCase().contains(query)).toList();

        final options = <Widget>[
          ...customerResults.map((customer) => ListTile(
            title: Text(customer['name'] ?? ''),
            subtitle: Text('Customer'),
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => CustomerDetail(customer: customer),
              //   ),
              // );
            },
          )),
          ...leadResults.map((lead) => ListTile(
            title: Text(lead['title'] ?? ''),
            subtitle: Text('Lead'),
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => LeadDetail(lead: lead),
              //   ),
              // );
            },
          )),
          ...dealResult.map((deal) => ListTile(
            title: Text(deal['title']??''),
            subtitle: Text('Deal'),
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_)=> DealDetail(deal : deal),
              //   ),
              // );
            },
          ))
        ];
        return options;
      },
    );
  }*/
}