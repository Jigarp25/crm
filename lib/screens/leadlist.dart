import 'package:crm/screens/leaddetails.dart';
import 'package:flutter/material.dart';
import '/screens/addlead.dart';
class LeadList extends StatelessWidget{
  final List<Map<String, String>> leads =[
    {
      'title': 'JP Corp ',
      'status':'Qualified',
      'assignedTo': 'dhruv',
    },
    {
      'title': 'Stark Industries ',
      'status':'Converted',
      'assignedTo': 'meet',
    },
    {
      'title': 'TATA pvt. ltd. ',
      'status':'Unqualified',
      'assignedTo': 'jigar',
    },
  ];

  Color _getStatusColor(String status){
    switch (status.toLowerCase()){
      case 'qualified':
        return Colors.green;
      case 'unqualified':
        return Colors.red;
      case 'converted':
        return Colors.blue;
      case 'unconverted':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leads'),
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
              title: Text(lead['title']??'',
                style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Assigned to ${lead['assignedTo']}'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(lead['status']??'').withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  lead['status']?? '',
                  style: TextStyle(
                    color: _getStatusColor(lead['status'] ?? ''),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              onTap: () {
                // TODO: Navigate to lead detail
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
      floatingActionButton: FloatingActionButton(
       onPressed:(){
        // Navigate to lead add screen
         Navigator.push(context, MaterialPageRoute(builder: (context) => AddLead()),);
      },
      child: const Icon(Icons.add , color: Colors.white,),
      backgroundColor: const Color(0xff5b3dde),
      ),
    );
  }
}