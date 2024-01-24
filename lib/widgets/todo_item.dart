import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/todo.dart';
import '../constants/colors.dart';

class ToDoItem extends StatefulWidget {
  final ToDo todo;
  final Function(ToDo) onDone;
  final Function(String) onDeleteItem;
  final Function(ToDo) onDetails;

  const ToDoItem({
    Key? key,
    required this.todo,
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
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          widget.onDetails(widget.todo);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        leading: Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.symmetric(vertical: 12),
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
              widget.todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
            ),
            onPressed: () {
              widget.onDone(widget.todo);
              setState(() {}); // Rebuild the widget when the state changes
            },
          ),
        ),
        title: Text(
          widget.todo.todoText!,
          style: TextStyle(
            fontSize: 16,
            color: tdBlack,
            decoration: widget.todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          'Expiration Date: ${DateFormat('yyyy-MM-dd').format(widget.todo.expirationDate!)}',
          style: TextStyle(
            fontSize: 14,
            color: tdGrey,
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.symmetric(vertical: 12),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: tdRed,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            color: Colors.white,
            iconSize: 18,
            icon: Icon(Icons.delete),
            onPressed: () {
              widget.onDeleteItem(widget.todo.id!);
            },
          ),
        ),
      ),
    );
  }
}
