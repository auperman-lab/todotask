import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' show AppBar, BorderRadius, BoxConstraints, BoxDecoration, BuildContext, Center, CircularProgressIndicator, Colors, Column, Container, EdgeInsets, Expanded, FontWeight, Icon, Icons, InputBorder, InputDecoration, ListView, MainAxisAlignment, Row, Scaffold, Stack, State, StatefulWidget, StreamBuilder, Text, TextField, TextStyle, Widget, showDialog;
import '../auth.dart';
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
  String _filterKeyword = ''; // Add a variable to store the filter keyword
  final Stream<QuerySnapshot<Map<String, dynamic>>> _stream = FirebaseFirestore.instance
      .collection("ToDo")
      .where('toDoState', isEqualTo: true)
      .where('uid', isEqualTo: Auth().currentUser?.uid)  // Add this condition
      .orderBy('toDoDate', descending: false) // Set 'descending' to true if you want to sort in descending order
      .snapshots()
      .handleError((error) {
    print('Error fetching ToDo items: $error');
  });


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

                      QuerySnapshot<Map<String, dynamic>> querySnapshot = snapshot.data as QuerySnapshot<Map<String, dynamic>>;

                      // Filter ToDo items based on the keyword
                      List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredTodos = querySnapshot.docs.where((todo) {
                        String title = todo['title'] ?? '';
                        String description = todo['descriptiom'] ?? '';

                        // Filter based on title or description containing the keyword
                        return title.toLowerCase().contains(_filterKeyword) || description.toLowerCase().contains(_filterKeyword);
                      }).toList();

                      return ListView.builder(
                        itemCount: filteredTodos.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data = filteredTodos[index].data() as Map<String, dynamic>;

                          return ToDoItem(
                            title: data["title"],
                            description: data["descriptiom"],
                            expirationDate: (data["toDoDate"] as Timestamp).toDate(),
                            completedDate: data["completedDate"] != null
                                ? (data["completedDate"] as Timestamp).toDate()
                                : null,                            isDone: data["toDoState"],
                            tid: data["tid"],
                            onDone: _handleToDoChange,
                            onDetails: _handleToDoDetails,
                            onDeleteItem: _deleteToDoItem,
                          );
                        },
                      );
                    },
                  )

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleToDoChange(String tid) async {
    CollectionReference todoCollection =
    FirebaseFirestore.instance.collection('ToDo');

    try {
      // Fetch the document reference based on tid
      QuerySnapshot<Object?> todoSnapshot =
      await todoCollection.where('tid', isEqualTo: tid).get();

      if (todoSnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> todoDoc = todoSnapshot.docs.first as DocumentSnapshot<Map<String, dynamic>>;
        bool currentToDoState = todoDoc['toDoState'] ?? false; // Default to false if the field is not present

        // Update the document with the new toDoState
        await todoCollection.doc(todoDoc.id).update({
          'toDoState': !currentToDoState,
        });
      }
    } catch (error) {
      print('Error updating todo state: $error');
      // Handle the error, e.g., show a message to the user
    }
  }


  void _handleToDoDetails(String tid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TodoDetailsPopup(tid: tid);
      },
    );
  }

  void _deleteToDoItem(String tid) async {
    CollectionReference todoCollection =
    FirebaseFirestore.instance.collection('ToDo');

    try {
      // Fetch the document reference based on tid
      QuerySnapshot<Object?> todoSnapshot =
      await todoCollection.where('tid', isEqualTo: tid).get();

      if (todoSnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> todoDoc = todoSnapshot.docs.first as DocumentSnapshot<Map<String, dynamic>>;
        // Delete the document
        await todoCollection.doc(todoDoc.id).delete();
      }
    } catch (error) {
      print('Error deleting todo item: $error');
      // Handle the error, e.g., show a message to the user
    }
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      _filterKeyword = enteredKeyword.toLowerCase(); // Convert keyword to lowercase for case-insensitive matching
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
