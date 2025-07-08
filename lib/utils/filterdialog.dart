// widgets/filter_dialog.dart
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../utils/ui_utils.dart';

Future<Map<String, String?>> showFilterDialog({
  required BuildContext context,
  required List<Map<String, String>> assignedUserList,
  required List<String> statusList,
  String? currentAssignedId,
  String? currentStatus,
  String title = 'Filter',
}) async {
  String? tempAssignedId = currentAssignedId;
  String? tempStatus = currentStatus;
  String? selectedAssignedName;
  if (currentAssignedId != null) {
    var match = assignedUserList.firstWhere(
          (e) => e['id'] == currentAssignedId,
      orElse: () => {},
    );
    selectedAssignedName = match['name'];
  } else {
    selectedAssignedName = null;
  }
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color(0xfffef7ff),
        title: Text('$title Options'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Assigned To Dropdown
              DropdownSearch<String>(
                items: assignedUserList.map((e) => e['name'] ?? '').toList(),
                selectedItem: selectedAssignedName,
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  menuProps: MenuProps(
                    backgroundColor: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: 'Assigned To',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                    filled: true,
                    fillColor: Color(0xffffffff),
                  ),
                ),
                onChanged: (value) {
                  var matched = assignedUserList.firstWhere(
                        (user) => user['name'] == value,
                    orElse: () => {'id': '', 'name': ''},
                  );
                  tempAssignedId = matched['id'];
                },
                clearButtonProps: const ClearButtonProps(isVisible: true),
              ),
              vSpace(),
              // Status Dropdown
              DropdownSearch<String>(
                items: statusList,
                selectedItem: tempStatus,
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  menuProps: MenuProps(
                    backgroundColor: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                    filled: true,
                    fillColor: Color(0xffffffff),
                  ),
                ),
                onChanged: (value) {
                  tempStatus = value == 'All' ? null : value;
                },
                clearButtonProps: const ClearButtonProps(isVisible: true),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffffffff)),
            onPressed: () {
              Navigator.pop(context, {
                'assignedTo': tempAssignedId,
                'status': tempStatus,
              });
            },
            child: const Text('Apply'),
          ),
        ],
      );
    },
  );

  return {
    'assignedTo': tempAssignedId,
    'status': tempStatus,
  };
}
