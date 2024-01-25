import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoDetailsPopup extends StatelessWidget {
  final String tid;

  const TodoDetailsPopup({Key? key, required this.tid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('ToDo').doc(tid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text('Document not found');
        } else {
          Map<String, dynamic> todo = snapshot.data!.data() as Map<String, dynamic>;
          return AlertDialog(
            title: Text('${todo["title"]}'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (todo["descriptiom"] != null && todo["descriptiom"].isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text('${todo["descriptiom"]}'),
                  ),
                Text(
                  // Format the date using DateFormat
                  DateFormat('yyyy-MM-dd').format((todo["toDoDate"] as Timestamp).toDate()),
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4.0),
                // Text(
                //   DateFormat('yyyy-MM-dd').format(todo["toDoDate"]),
                //   style: const TextStyle(
                //     fontSize: 20,
                //   ),
                // ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        }
      },
    );
  }
}
