import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoDetailsPopup extends StatelessWidget {
  final String tid;

  const TodoDetailsPopup({Key? key, required this.tid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchTodoDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('Todo not found');
        } else {
          Map<String, dynamic> todoData = snapshot.data as Map<String, dynamic>;

          DateTime expirationDate =
          (todoData['toDoDate'] as DateTime);

          return AlertDialog(
            title: Text('${todoData['title']}'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (todoData['descriptiom'] != null &&
                    todoData['descriptiom'].isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text('${todoData['descriptiom']}'),
                  ),
                const Text(
                  'Due',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  DateFormat('yyyy-MM-dd').format(expirationDate),
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
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

  Future<Map<String, dynamic>> _fetchTodoDetails() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('ToDo')
        .where('tid', isEqualTo: tid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var todoData = querySnapshot.docs.first.data() as Map<String, dynamic>;

      // Check if expirationDate is not null before casting
      if (todoData['toDoDate'] != null) {
        todoData['toDoDate'] =
            (todoData['toDoDate'] as Timestamp).toDate();
      }

      return todoData;
    } else {
      return Future.error('Todo not found');
    }
  }

}
