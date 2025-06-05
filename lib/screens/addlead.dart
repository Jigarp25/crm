import 'package:flutter/material.dart';

class AddLead extends StatefulWidget {
  const AddLead({super.key});

  @override
  State<AddLead> createState() => _AddLeadState();
}

class _AddLeadState extends State<AddLead> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _assignedToController = TextEditingController();

  String? _selectedStatus;
  final List<String> _statusOptions = [
    'Qualified',
    'Unqualified',
    'Converted',
    'Unconverted',
  ];

  void _handleSubmit() {
    if (_formKey.currentState?.validate() != true) return;

    final title = _titleController.text.trim();
    final assignedTo = _assignedToController.text.trim();
    final status = _selectedStatus;

    if (title.isEmpty || assignedTo.isEmpty || status == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // TODO: Add Logic to save lead
    print('New Lead: $title, Assigned to: $assignedTo, Status: $status');

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Add Lead', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
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
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Lead Title',
                  labelStyle: const TextStyle(color: Color(0xff000000)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Status',
                  labelStyle: const TextStyle(color: Color(0xff000000)),
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
              const SizedBox(height: 16),
              TextField(
                controller: _assignedToController,
                decoration: InputDecoration(
                  labelText: 'Assigned To',
                  labelStyle: const TextStyle(color: Color(0xff000000)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff5b3dde),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      color: Color(0xfffffffff),
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
