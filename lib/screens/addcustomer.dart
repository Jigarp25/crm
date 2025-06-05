import 'package:flutter/material.dart';


class AddCustomer extends StatefulWidget{
  const AddCustomer({super.key});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer>{
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactnoController = TextEditingController();
  final _companymnameController = TextEditingController();
  final _buildingnameController = TextEditingController();
  final _areaController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  String? validatPincode(String pincode){
    if (pincode.length < 6) return 'please enter validate pincode';
    return null;
  }
  void _handleSubmit(){
    if (_formKey.currentState?.validate() != true)
      return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final contactno = _contactnoController.text.trim();
    final companyname = _companymnameController.text.trim();
    final pincode = _pincodeController.text.trim();
    
    if(name.isEmpty || email.isEmpty|| contactno.isEmpty || companyname.isEmpty||pincode.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }
    // TODO : Add Logic save customer
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Add Customer', style: TextStyle(fontWeight:FontWeight.w700)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right:12),
            child: GestureDetector(
              onTap:(){
                Navigator.pop(context);
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.close, color:Colors.black),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             RichText(
                 text: TextSpan(
                   text: 'Name',
                   style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18,color: Color(0xff000000)),
                   children: const[
                     TextSpan(
                       text: '*',
                       style: TextStyle(color: Color(0xffff0000)),
                     ),
                   ],
                 )
             ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  filled:true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height:16 ),
              RichText(
                  text: TextSpan(
                    text: 'E-mail',
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18,color: Color(0xff000000)),
                    children: const[
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Color(0xffff0000)),
                      ),
                    ],
                  )
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled:true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              RichText(
                  text: TextSpan(
                    text: 'Conatact No',
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18,color: Color(0xff000000)),
                    children: const[
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Color(0xffff0000)),
                      ),
                    ],
                  )
              ),
              TextFormField(
                controller: _contactnoController,
                decoration: InputDecoration(
                  filled:true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              RichText(
                  text: TextSpan(
                    text: 'Comapany Name',
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18,color: Color(0xff000000)),
                    children: const[
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Color(0xffff0000)),
                      ),
                    ],
                  )
              ),
              TextFormField(
                controller: _companymnameController,
                decoration: InputDecoration(
                  filled:true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Address',textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
              TextFormField(
                controller: _buildingnameController,
                decoration: InputDecoration(
                  labelText: 'Building Name',
                  filled:true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _areaController,
                decoration: InputDecoration(
                  labelText: 'Area Name',
                  filled:true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                  filled:true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stateController,
                decoration:  InputDecoration(
                  labelText: 'State',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pincodeController,
                decoration:  InputDecoration(
                  label: Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          WidgetSpan(child: Text('pincode')),
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
              SizedBox(
                height: 24,
                child: Text('* shows field is required',style: TextStyle(color: Color(0xffff0000)),),
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff5b3dde),
                    minimumSize: Size(60 , 50)
                  ),
                    onPressed:
                    //TODO: add Customer
                      _handleSubmit,
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white,fontSize: 20),
                  ),
                ),
              ),

              const SizedBox(height: 200)
            ],
          ),
        )
      ),
    );
  }
}

