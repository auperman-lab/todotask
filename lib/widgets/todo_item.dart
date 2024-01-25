import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/colors.dart';

class ToDoItem extends StatefulWidget {
  final String title;
  final String description;
  final DateTime expirationDate;
  final bool isDone;
  final String tid;
  final Function(String) onDone;
  final Function(String) onDeleteItem;
  final Function(String) onDetails;

  const ToDoItem({
    Key? key,
    required this.title,
    required this.description,
    required this.expirationDate,
    required this.tid,
    required this.isDone,
    required this.onDone,
    required this.onDeleteItem,
    required this.onDetails,
  }) : super(key: key);

  @override
  _ToDoItemState createState() => _ToDoItemState();
}

class _ToDoItemState extends State<ToDoItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          widget.onDetails(widget.tid);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        leading: Container(
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.symmetric(vertical: 12),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            color: Colors.blue,
            iconSize: 18,
            icon: Icon(
              widget.isDone ? Icons.check_box : Icons.check_box_outline_blank,
            ),
            onPressed: () {
              widget.onDone(widget.tid);
              setState(() {}); // Rebuild the widget when the state changes
            },
          ),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 16,
            color: tdBlack,
            decoration: widget.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          'Expiration Date: ${DateFormat('yyyy-MM-dd').format(widget.expirationDate)}',
          style: const TextStyle(
            fontSize: 14,
            color: tdGrey,
          ),
        ),
        trailing: Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.all(0),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: tdRed,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            color: Colors.white,
            iconSize: 18,
            icon: const Icon(Icons.delete),
            onPressed: () {
              widget.onDeleteItem(widget.tid);
            },
          ),
        ),
      ),
    );
  }
}
