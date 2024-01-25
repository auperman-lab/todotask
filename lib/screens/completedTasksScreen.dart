import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' show AppBar, BorderRadius, BoxConstraints, BoxDecoration, BuildContext, Center, CircularProgressIndicator, Colors, Column, Container, EdgeInsets, Expanded, FontWeight, Icon, Icons, InputBorder, InputDecoration, ListView, MainAxisAlignment, Row, Scaffold, Stack, State, StatefulWidget, StreamBuilder, Text, TextField, TextStyle, Widget, showDialog;
import '../constants/colors.dart';
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
  final Stream<QuerySnapshot<Map<String, dynamic>>> _stream = FirebaseFirestore.instance.collection("ToDo").snapshots();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      drawer: const AppMenu(),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Column(
              children: [
                searchBox(),
                Container(
                  margin: const EdgeInsets.only(
                    top: 50,
                    bottom: 20,
                  ),
                  child: const Text(
                    'Completed Tasks',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: _stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;

                      return ListView.builder(
                        itemCount: querySnapshot.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data = querySnapshot.docs[index].data() as Map<String, dynamic>;

                          return ToDoItem(
                            title: data["title"],
                            description: data["descriptiom"],
                            expirationDate: (data["toDoDate"] as Timestamp).toDate(),
                            isDone: data["toDoState"],
                            tid: data["tid"],
                            onDone: _handleToDoChange,
                            onDetails: _handleToDoDetails,
                            onDeleteItem: _deleteToDoItem,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleToDoChange(String tid) {
  }

  void _handleToDoDetails(String tid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TodoDetailsPopup(tid: tid);
      },
    );
  }

  void _deleteToDoItem(String id) {

  }

  void _runFilter(String enteredKeyword) {

  }


  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
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
