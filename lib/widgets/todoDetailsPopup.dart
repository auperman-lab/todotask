import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/todo.dart';
import '../constants/colors.dart';

class TodoDetailsPopup extends StatelessWidget {
  final ToDo todo;

  const TodoDetailsPopup({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${todo.todoText}'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (todo.description != null && todo.description!.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 8.0), // Adjust the space as needed
              child: Text('${todo.description}'),
            ),
          Text(
            'Due',
            style: TextStyle(
              fontSize: 16, // Same font size as the title
            ),
          ),
          SizedBox(height: 4.0), // Add some space between "Due" and the date
          Text(
            DateFormat('yyyy-MM-dd').format(todo.expirationDate!),
            style: TextStyle(
              fontSize: 20, // Same font size as the title
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
