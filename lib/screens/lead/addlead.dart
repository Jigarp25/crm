import 'package:crm/screens/lead/controller.dart';
import 'package:crm/services/dummydata.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import '../../utils/ui_utils.dart';
import '../../widgets/buttons.dart';

class AddLead extends StatefulWidget {
  const AddLead({super.key});

  @override
  State<AddLead> createState() => _AddLeadState();
}

class _AddLeadState extends State<AddLead>{
  late LeadController controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = Provider.of<LeadController>(context);
  }


  final List<String> _statusOptions = [
    'Qualified',
    'Unqualified',
    'Converted',
    'Unconverted',
  ];

  void _handleSubmit() {
    if (controller.formKey.currentState?.validate() != true) return;

    var title = controller.txtTitle.text.trim();
    var assignedTo = controller.selectedAssignedTo;
    var status = controller.selectedStatus;


    if (title.isEmpty || assignedTo == null || status == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // TODO: Add Logic to save lead

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Add Lead'),
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
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: TextSpan(
                    text: 'Lead Title',
                    style: const TextStyle( fontSize: 18,color: Color(0xff000000)),
                    children: const[
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Color(0xffff0000)),
                      ),
                    ],
                  )
              ),
              TextFormField(
                controller: controller.txtTitle,
                decoration: inputDecoration(hint: 'Lead Title'),
                validator: (value) => ((value == null || value.trim().isEmpty) ? 'Title is required': null),
              ),
              vSpace(),
              RichText(
                  text: TextSpan(
                    text: 'Company name',
                    style: const TextStyle( fontSize: 18,color: Color(0xff000000)),
                    children: const[
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Color(0xffff0000)),
                      ),
                    ],
                  )
              ),
              // Company Name
              TextFormField(
                controller: controller.txtCompanyName,
                validator: (value) =>
                (value == null || value.trim().isEmpty) ? 'Company name is required' : null,
                decoration: inputDecoration(hint: 'Company Name'),
              ),

              vSpace(),
              RichText(
                  text: TextSpan(
                    text: 'E-mail',
                    style: const TextStyle( fontSize: 18,color: Color(0xff000000)),
                    children: const[
                      TextSpan(
                        text: '',
                        style: TextStyle(color: Color(0xffff0000)),
                      ),
                    ],
                  )
              ),
              TextFormField(
                controller: controller.txtEmail,
                decoration: inputDecoration( hint: 'Lead Email'),
              ),
              vSpace(),
              RichText(
                  text: TextSpan(
                    text: 'Contact No.',
                    style: const TextStyle( fontSize: 18,color: Color(0xff000000)),
                    children: const[
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Color(0xffff0000)),
                      ),
                    ],
                  )
              ),
              IntlPhoneField(
                decoration: inputDecoration(hint: 'Phone No'),
                initialCountryCode: 'IN',
                onChanged: (phone){
                  controller.txtPhone.text = phone.completeNumber;
                  },
              ),
              vSpace(),
              RichText(
                  text: TextSpan(
                    text: 'Status',
                    style: const TextStyle( fontSize: 18,color: Color(0xff000000)),
                    children: const[
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Color(0xffff0000)),
                      ),
                    ],
                  )
              ),
              DropdownButtonFormField<String>(
                value: controller.selectedStatus,
                decoration: inputDecoration(hint: 'Select Status'),
                items: _statusOptions
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (value) => setState(() => controller.selectedStatus = value),
              ),
              vSpace(),
              RichText(
                  text: TextSpan(
                    text: 'Customer',
                    style: const TextStyle( fontSize: 18,color: Color(0xff000000)),
                    children: const[
                      TextSpan(
                        text: '',
                        style: TextStyle(color: Color(0xffff0000)),
                      ),
                    ],
                  )
              ),
              DropdownButtonFormField<String>(
                value: controller.selectedCustomer,
                  decoration: inputDecoration(hint: 'Select Customer'),
                  items: controller.customerList.map((name) => DropdownMenuItem(value: name,child: Text(name))).toList(),
                  onChanged: (value) {
                  if (value != null) controller.onCustomerSelected(value);
                  },
              ),
              vSpace(),
              RichText(
                  text: TextSpan(
                    text: 'Assigned To',
                    style: const TextStyle( fontSize: 18,color: Color(0xff000000)),
                    children: const[
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Color(0xffff0000)),
                      ),
                    ],
                  )
              ),
              DropdownButtonFormField<String>(
                value: controller.selectedAssignedTo,
                  decoration: inputDecoration(hint: 'Select Assign'),
                  items: controller.assignedUserList.map((user) => DropdownMenuItem(value: user ,child: Text(user))).toList(),
                  onChanged: (value){
                  controller.selectedAssignedTo = value;
                  }
              ),
              RichText(
                  text: TextSpan(
                    text: 'Description',
                    style: const TextStyle( fontSize: 18,color: Color(0xff000000)),
                    children: const[
                      TextSpan(
                        text: '',
                        style: TextStyle(color: Color(0xffff0000)),
                      ),
                    ],
                  )
              ),
              TextFormField(
                controller: controller.txtDescription,
                decoration: inputDecoration( hint: 'Lead Tile'),
              ),
              SizedBox(
                height: 24,
                child: Text('* shows field is required',style: TextStyle(color: Color(0xffff0000)),),
              ),
              SizedBox(
                width: double.infinity,
                child: elevatedButton(
                  onPressed:() async => _handleSubmit(),
                  label:'Submit',
                ),
              ),
              vSpace()
            ],
          ),
        ),
      ),
    );
  }
}
