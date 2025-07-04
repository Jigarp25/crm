import 'package:crm/screens/lead/controller.dart';
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
  void initState() {
    super.initState();
    controller.loadDropDownData();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = Provider.of<LeadController>(context);
  }


  Future<void> _handleSubmit() async {
    if (controller.formKey.currentState?.validate() != true) return;

    var title = controller.txtTitle.text.trim();
    var assignedTo = controller.selectedAssignedTo;
    var customerId = controller.selectedCustomerId;
    var status = controller.selectedStatus;


    if (title.isEmpty || assignedTo == null ||customerId == null|| status == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Logic to save lead
    var error = await controller.leadSubmit();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

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
                items: controller.leadStatusOptions
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
                        text: '*',
                        style: TextStyle(color: Color(0xffff0000)),
                      ),
                    ],
                  )
              ),
              DropdownButtonFormField<String>(
                value: controller.selectedCustomerId,
                decoration: inputDecoration(hint: 'Select Customer'),
                items: controller.customerList
                    .map<DropdownMenuItem<String>>((customer) => DropdownMenuItem<String>(
                  value: customer['id'],
                  child: Text(customer['name'] ?? ''),
                )).toList(),
                onChanged: (value) {
                  var selected = controller.customerList.firstWhere((c) => c['id'] == value);
                  controller.selectedCustomerId = selected['id'];
                  controller.selectedCustomerName = selected['name'];
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
                items: controller.assignedUserList
                    .map<DropdownMenuItem<String>>((user) => DropdownMenuItem<String>(
                  value: user['id'],
                  child: Text(user['name'] ?? ''),
                ))
                    .toList(),
                onChanged: (value) {
                  var selected = controller.assignedUserList.firstWhere((u) => u['id'] == value);
                  controller.selectedAssignedTo = selected['id'];
                  controller.selectedAssignedName = selected['name'];
                  setState(() {});
                },
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
