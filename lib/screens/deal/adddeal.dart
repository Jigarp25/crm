import 'package:crm/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:crm/widgets/detailrow.dart';

import '../../widgets/buttons.dart';

class AddDeal extends StatefulWidget{
  final Map<String,String>? lead;

  const AddDeal({super.key, this.lead});

  @override
  State<AddDeal> createState() => _AddDealState();
}

class _AddDealState extends State<AddDeal>{
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _assignedToController = TextEditingController();
  final _companynameController= TextEditingController();
  final _customerController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedStatus;
  final List<String> _statusOptions = [
    'Proposal Sent',
    'Negotiation',
    'Won',
    'Lost',
    'On Hold',
    'No Response'
  ];

  bool get _isFromLead => widget.lead != null;

  late final Map<String, String>? lead;

  @override
  void initState() {
    super.initState();
    lead = widget.lead;
    if(_isFromLead) {
      final lead = widget.lead!;
      _titleController.text = lead['title'] ?? '';
      _assignedToController.text = lead['assignedTo'] ?? '';
      _companynameController.text = lead['companyname'] ?? '';
      _customerController.text = lead['customer'] ?? '';
      _descriptionController.text = lead['description'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:  Text( _isFromLead ?'Convert to Deal':'Add Deal'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right:12),
            child:
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: CircleAvatar(
                child: const Icon(Icons.close,color: Color(0xff000000),),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      spreadRadius: 3,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailRow(label: 'Deal title:', value: widget.lead?['title'] ?? ''),
                    vSpace(8),
                    DetailRow(label: 'Assigned To:', value: widget.lead?['assignedTo'] ?? ''),
                    vSpace(8),
                    DetailRow(label: 'Company Name:', value: widget.lead?['companyName'] ?? ''),
                    vSpace(8),
                    DetailRow(label: 'Customer:', value: widget.lead?['customer'] ?? ''),
                    vSpace(8),
                    DetailRow(label: 'Description:', value: widget.lead?['description'] ?? ''),
                    vSpace(8),

                  ],
                ),
              ),
              vSpace(),
              const Text('Amount',style: TextStyle(fontSize: 18)),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  hintText: 'Enter Amount',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)
                  ),
                ),
              ),
              vSpace(),
              const Text('Status', style: TextStyle(fontSize: 18)),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  hintText: 'Select Status',
                  filled: true,
                  fillColor: const Color(0xffffffff),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _statusOptions
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedStatus = value),
              ),
              vSpace(24),
              SizedBox(
                width: double.infinity,
                child: elevatedButton(
                  onPressed: () async {
                    // todo: handle Submit
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
