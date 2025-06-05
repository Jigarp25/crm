import 'package:flutter/material.dart';

class LeadDetail extends StatelessWidget {
  final Map<String, String> lead;

  const LeadDetail({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    final title = lead['title'] ?? 'Lead Detail';
    final assignedto = lead['assignedTo'] ?? 'Not Available';
    final status = lead['status'] ?? 'New';

    return Scaffold(
      appBar: AppBar(
        title: Text(title, overflow: TextOverflow.ellipsis),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                // TODO: Navigate to Edit lead
              },
              child: const Icon(Icons.edit_outlined),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 160,
                  color: const Color(0xff1F1453),
                ),
                Positioned(
                  top: 30,
                  left: 30,
                  right: 30, // add right spacing to avoid overflow
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xffeaddff),
                        child: Text(
                          title[0],
                          style: const TextStyle(
                            fontSize: 50,
                            color: Color(0xff4f378b),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Assigned To: $assignedto',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            ListTile(
              title: const Text(
                'Status',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              subtitle: Text(
                status,
                style: const TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
