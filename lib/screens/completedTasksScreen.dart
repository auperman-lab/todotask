import 'package:flutter/material.dart' show AppBar, BorderRadius, BoxConstraints, BoxDecoration, BuildContext, Colors, Column, Container, EdgeInsets, Expanded, FontWeight, Icon, Icons, InputBorder, InputDecoration, ListView, MainAxisAlignment, Row, Scaffold, State, StatefulWidget, Text, TextEditingController, TextField, TextStyle, Widget, showDialog;
import '../constants/colors.dart';
import '../model/todo.dart';
import '../widgets/appMenu.dart';
import '../widgets/todoDetailsPopup.dart';
import '../widgets/todo_item.dart';

class CompletedTasksScreen extends StatefulWidget {
  static const String routeName = "/completed_tasks";
  const CompletedTasksScreen({super.key});

  @override
  _CompletedTasksScreenState createState() => _CompletedTasksScreenState();


}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  final _todoController = TextEditingController();
  final todosList = ToDo.todoList();
  List<ToDo> _foundToDo = [];

  @override
  void initState() {
    print("filtering rn");
    _runFilter(_todoController.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      drawer: const AppMenu(),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          searchBox(),
          Expanded(
            child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 50,
                    bottom: 20,
                  ),
                  child: const Text(
                    'All Done',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                for (ToDo todoo in _foundToDo.reversed)
                  ToDoItem(
                    todo: todoo,
                    onDone: _handleToDoChange,
                    onDetails: _handleToDoDetails,
                    onDeleteItem: _deleteToDoItem,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    todo.isDone = !todo.isDone;
    // Handle other state changes or side effects as needed
  }

  void _handleToDoDetails(ToDo todo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TodoDetailsPopup(todo: todo);
      },
    );
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
      _foundToDo.removeWhere((item) => item.id == id);
    });
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      _foundToDo = todosList
          .where((item) => item.isDone && item.todoText!
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase()))
          .toList();
    });
  }


  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _todoController,
        onChanged: (value) {
          _runFilter(value);
        },
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Add your AppBar content here
        ],
      ),
    );
  }
}
