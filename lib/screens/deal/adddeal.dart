import 'package:crm/firebase/Model/Lead.dart';
import 'package:crm/screens/deal/controller.dart';

import 'package:crm/screens/home/mainscreen.dart';
import 'package:crm/screens/lead/controller.dart';
import 'package:crm/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:crm/widgets/detailrow.dart';
import 'package:provider/provider.dart';
import '../../widgets/buttons.dart';


class AddDeal extends StatefulWidget {
  final LeadModel lead;

  const AddDeal({super.key, required this.lead});

  @override
  State<AddDeal> createState() => _AddDealState();
}

class _AddDealState extends State<AddDeal> {

   DealController _controller = DealController();

  @override
  void initState() {
    super.initState();
    _controller.initFromLead(widget.lead);
  }

  String assignedName = 'Loading...';
  String customerName = 'Loading...';
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      var leadController = Provider.of<LeadController>(context, listen: false);

      var assignedUser = leadController.assignedUserList.firstWhere(
            (u) => u['id'] == widget.lead.assignedTo,
        orElse: () => {'name': 'Unknown'},
      );

      var customer = leadController.customerList.firstWhere(
            (c) => c['id'] == widget.lead.customerId,
        orElse: () => {'name': 'Unknown'},
      );

      assignedName = assignedUser['name'] ?? 'Unknown';
      customerName = customer['name'] ?? 'Unknown';

      _isInitialized = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Convert to Deal'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const CircleAvatar(
                child: Icon(Icons.close, color: Color(0xff000000)),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(50),
                      spreadRadius: 3,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailRow(label: 'Deal title:', value: widget.lead.title ?? ''),
                    vSpace(8),
                    DetailRow(label: 'Assigned To:', value: assignedName),
                    vSpace(8),
                    DetailRow(label: 'Company Name:', value: widget.lead.companyName ?? ''),
                    vSpace(8),
                    DetailRow(label: 'Customer:', value: customerName),
                    vSpace(8),
                    DetailRow(label: 'Description:', value: widget.lead.description ?? ''),
                    vSpace(8),
                  ],
                ),
              ),
              vSpace(),
              const Text('Amount', style: TextStyle(fontSize: 18)),
              TextFormField(
                controller: _controller.txtAmount,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter amount';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Amount',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              vSpace(),
              const Text('Status', style: TextStyle(fontSize: 18)),
              DropdownButtonFormField<String>(
                value: _controller.selectedStatus,
                decoration: InputDecoration(
                  hintText: 'Select Status',
                  filled: true,
                  fillColor: const Color(0xffffffff),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _controller.dealStatus.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _controller.selectedStatus = value;
                  });
                },
                validator: (value) =>
                value == null || value.isEmpty ? 'Please select status' : null,
              ),
              vSpace(24),
              SizedBox(
                width: double.infinity,
                child: elevatedButton(
                  onPressed: () async {
                    if (_controller.validateForm()) {
                      var error = await _controller.submitDeal(lead: widget.lead);

                      if (error == null) {
                        if (mounted) {
                          Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder:(_) =>  MainScreen()
                              )
                          );
                        }
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error)),
                          );
                        }
                      }
                    }
                  },

                  label: 'Submit',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
