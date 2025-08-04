import 'package:crm/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:validators/validators.dart';
import '../../widgets/buttons.dart';
import 'controller.dart';
import 'package:provider/provider.dart';
import '/utils/ui_utils.dart';

class AddCustomer extends StatefulWidget{
  const AddCustomer({super.key});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer>{
  late CustomerController controller;

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    controller = Provider.of<CustomerController>(context);
  }

  void _handleSubmit() async{
    var originalEmail = controller.txtEmail.text.trim();
    var result = await controller.submitCustomerForm();

    if (result != null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)),
      );
    }else{
      if(originalEmail.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email was not provided. Saved as "Not Available".')),
        );
      }
      Navigator.pop(context);
    }
   }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Add Customer'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right:12),
            child: GestureDetector(
              onTap:(){
                Navigator.pop(context);
              },
              child: CircleAvatar(
                // backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.close, color:Colors.black),
              ),
            ),
          ),
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
                   text: 'Customer Name',
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
                controller: controller.txtName,
                decoration: inputDecoration(
                  hint: ' Name'
                ),
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
                validator: (value) => Validators.validateOptionalEmail(value),
                decoration: inputDecoration(
                  hint: 'Customer Email'
                ),
              ),
              vSpace(),
              RichText(
                  text: TextSpan(
                    text: 'Contact No',
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
                  controller.txtPhoneNo.text = phone.completeNumber;
                },
              ),
              vSpace(),
              RichText(
                  text: TextSpan(
                    text: 'Company Name',
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
                controller: controller.txtCompanyName,
                decoration: inputDecoration(
                  hint: 'Company Name'
                ),
              ),
              vSpace(),
              Text('Address',textAlign: TextAlign.left,
              style: TextStyle( fontSize: 18)),
              TextFormField(
                controller: controller.txtBuildingName,
                decoration: InputDecoration(
                  labelText: 'Building Name',
                  filled:true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              vSpace(),
              TextFormField(
                controller: controller.txtArea,
                decoration: InputDecoration(
                  labelText: 'Area Name',
                  filled:true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              vSpace(),
              TextFormField(
                controller: controller.txtCity,
                decoration: InputDecoration(
                  labelText: 'City',
                  filled:true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              vSpace(),
              TextFormField(
                controller: controller.txtState,
                decoration:  InputDecoration(
                  labelText: 'State',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              vSpace(),
              TextFormField(
                controller: controller.txtPincode,
                validator: (value)=>isNumeric(value ?? '') && value!.length == 6 ? null: 'Invalid pincode',
                keyboardType: TextInputType.number,
                decoration:  InputDecoration(
                  label: Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          WidgetSpan(child: Text('Pincode')),
                          WidgetSpan(child: Text('*',style: TextStyle(color: Color(0xffff0000)),))
                        ]
                      )
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 24,
                //child: Text('* shows field is required',style: TextStyle(color: Color(0xffff0000)),),
              // ),
              vSpace(),
              SizedBox(
                width: double.infinity,
                child: elevatedButton(
                  onPressed:() async => _handleSubmit(),
                  label: 'Submit'
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}

