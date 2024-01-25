import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../auth.dart';
import '../constants/colors.dart';
import '../widgets/addTaskOverlay.dart';
import '../widgets/todo_item.dart';
import '../widgets/appMenu.dart';

class TaskToDo extends StatefulWidget {
  static const String routeName = "/tasktodo";

  const TaskToDo({Key? key}) : super(key: key);

  @override
  State<TaskToDo> createState() => _TaskToDoState();
}

class _TaskToDoState extends State<TaskToDo> {
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
                    'Tasks To Do',
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
          Align(
            alignment: Alignment.bottomRight,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      _showAddTaskOverlay(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tdBlue,
                      minimumSize: const Size(60, 60),
                      elevation: 10,
                    ),
                    child: const Text(
                      '+',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
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

  }


  void _deleteToDoItem(String id) {

  }

  void _showAddTaskOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BottomSlideInput(
          onSubmit: (taskName, taskDescription, taskDate) {
            if (kDebugMode) {
              print(
                  'Added task: $taskName, Description: $taskDescription, Date: $taskDate');
            }
            _addToDoItem(taskName, taskDescription, taskDate);
            Navigator.pop(context); // Close the BottomSlideInput
          },
        );
      },
    );
  }

  void _addToDoItem(
      String _title, String _description, DateTime? _expirationDate) {
    String _uid = Auth().currentUser!.uid;
    String _tid = Uuid().v4(); // Generate a unique ID


    FirebaseFirestore.instance.collection("ToDo").add({
      "title": _title,
      "descriptiom" : _description,
      "toDoState" : false,
      "toDoDate" : _expirationDate,
      "uid" : _uid,
      "tid" : _tid
    });


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
        onChanged: (value) => _runFilter(value),
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
        ],
      ),
    );
  }
}
