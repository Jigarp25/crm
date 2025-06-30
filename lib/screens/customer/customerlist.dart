import 'package:crm/screens/customer/controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/buttons.dart';
import 'addcustomer.dart';
import 'customerdetail.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({super.key});
  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  @override
  void initState() {
    super.initState();
    Provider.of<CustomerController>(context, listen: false).loadCustomers();
  }

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<CustomerController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer list'),
        actions: [
          _appSearchAnchor(context, controller),
        ],
      ),
      body: Consumer<CustomerController>(
        builder: (context, controller, _) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          var customers = controller.customers;

          if (customers.isEmpty) {
            return const Center(child: Text('No customers found'));
          }

          return ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              var customer = customers[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      (customer.name?.isNotEmpty ?? false)
                          ? customer.name![0].toUpperCase()
                          : '?',
                    ),
                  ),
                  title: Text(customer.name ?? 'No Name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Company Name: ${customer.companyName ?? 'Not Available'}'),
                      Text('Email: ${customer.email ?? 'Not Available'}'),
                      Text('Phone: ${customer.phoneNo ?? 'Not Available'}'),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CustomerDetail(customer: customer),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: floatingButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (_) => CustomerController(),
                child: const AddCustomer(),
              ),
            ),
          );

          // Refresh only if a customer was added
          if (result == true) {
            final controller =
            Provider.of<CustomerController>(context, listen: false);
            controller.loadCustomers();
          }
        },
        icon: Icons.add,
      ),
    );
  }

  Widget _appSearchAnchor(BuildContext context, CustomerController controller) {
    return SearchAnchor(
      builder: (_, SearchController searchController) {
        return IconButton(
          icon: const Icon(Icons.search),
          onPressed: searchController.openView,
        );
      },
      suggestionsBuilder: (_, SearchController searchController) async {
        var query = searchController.text.toLowerCase();
        await Future.delayed(const Duration(milliseconds: 300));
        if (query.isEmpty) return [];

        var results = controller.searchCustomers(query);
        return results.map((customer) {
          return ListTile(
            title: Text(customer.name ?? 'Unknown'),
            subtitle: const Text('Customer'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CustomerDetail(customer: customer),
                ),
              );
            },
          );
        }).toList();
      },
    );
  }
}
