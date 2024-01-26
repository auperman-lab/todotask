import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cron/cron.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/auth.dart';
import 'package:uuid/uuid.dart';

import '../constants/colors.dart';
import '../widgets/addTaskOverlay.dart';
import '../widgets/todoDetailsPopup.dart';
import '../widgets/todo_item.dart';
import '../widgets/appMenu.dart';

class Home extends StatefulWidget {
  static const String routeName = "/";

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _filterKeyword = ''; // Add a variable to store the filter keyword
  late Cron _cron;
  final Stream<QuerySnapshot<Map<String, dynamic>>> _stream =
  FirebaseFirestore.instance
      .collection("ToDo")
      .where('uid', isEqualTo: Auth().currentUser?.uid)
      .snapshots()
      .handleError((error) {
    print('Error fetching ToDo items: $error');
  });

  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) => {
      if (!isAllowed) {AwesomeNotifications().requestPermissionToSendNotifications()}
    });

    _cron = Cron();

    // Schedule the checkNotifications function to run every minute
    _cron.schedule(Schedule.parse('*/1 * * * *'), () {
      _checkNotifications();
    });
    super.initState();
  }

  @override
  void dispose() {
    // Stop the cron job when the widget is disposed
    _cron.close();
    super.dispose();
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
                    'All ToDos',
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

                      QuerySnapshot<Map<String, dynamic>> querySnapshot =
                      snapshot.data as QuerySnapshot<Map<String, dynamic>>;

                      // Filter ToDo items based on the keyword
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>
                      filteredTodos = querySnapshot.docs
                          .where((todo) {
                        String title = todo['title'] ?? '';
                        String description = todo['descriptiom'] ?? '';

                        // Filter based on title or description containing the keyword
                        return title.toLowerCase().contains(_filterKeyword) ||
                            description.toLowerCase().contains(_filterKeyword);
                      })
                          .toList();

                      // Sort the filteredTodos based on the 'toDoDate' field
                      filteredTodos.sort((a, b) {
                        DateTime? dateA = a['toDoDate']?.toDate();
                        DateTime? dateB = b['toDoDate']?.toDate();

                        if (dateA == null && dateB == null) {
                          return 0;
                        } else if (dateA == null) {
                          return 1; // Move documents without 'toDoDate' to the end
                        } else if (dateB == null) {
                          return -1; // Move documents without 'toDoDate' to the end
                        } else {
                          return dateA.compareTo(dateB);
                        }
                      });

                      return ListView.builder(
                        itemCount: filteredTodos.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data =
                          filteredTodos[index].data() as Map<String, dynamic>;

                          return ToDoItem(
                            title: data["title"],
                            description: data["descriptiom"],
                            expirationDate: (data["toDoDate"] as Timestamp).toDate(),
                            completedDate: data["completedDate"] != null
                                ? (data["completedDate"] as Timestamp).toDate()
                                : null,
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

  void _createNotification(String title, String hours) {
    if (hours == '0') {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 0,
          channelKey: 'basic_chanel',
          title: 'You ran out time',
          body: 'The deadline of $title task has expired',
        ),
      );
    } else {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'basic_chanel',
          title: 'The Deadline is approaching',
          body: 'You have $hours left until the $title task expires',
        ),
      );
    }
  }

  void _checkNotifications() {
    FirebaseFirestore.instance
        .collection('ToDo')
        .where('uid', isEqualTo: Auth().currentUser?.uid)
        .get()
        .then((querySnapshot) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> document
      in querySnapshot.docs) {
        Map<String, dynamic> data = document.data();
        String title = data['title'] ?? '';
        DateTime expirationDate = (data['toDoDate'] as Timestamp).toDate();

        // Calculate the difference between expirationDate and current time
        Duration difference = expirationDate.difference(DateTime.now());
        double hoursRemaining = difference.inMinutes / 60;

        // Check if there are 24 hours or 1 hour remaining
        if (hoursRemaining <= 24.0 && hoursRemaining > 23.0) {
          _createNotification(title, '24.0');
        } else if (hoursRemaining <= 1.0 && hoursRemaining > 0.0) {
          _createNotification(title, '1.0');
        }
      }
    });
  }

  void _handleToDoChange(String tid) async {
    CollectionReference todoCollection =
    FirebaseFirestore.instance.collection('ToDo');

    try {
      // Fetch the document reference based on tid
      QuerySnapshot<Object?> todoSnapshot =
      await todoCollection.where('tid', isEqualTo: tid).get();

      if (todoSnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> todoDoc =
        todoSnapshot.docs.first as DocumentSnapshot<Map<String, dynamic>>;
        bool currentToDoState = todoDoc['toDoState'] ?? false; // Default to false if the field is not present

        // Update the document with the new toDoState
        await todoCollection.doc(todoDoc.id).update({
          'toDoState': !currentToDoState,
          'completedDate': !currentToDoState ? FieldValue.serverTimestamp() : null,
        });
      }

      print('updating page');
      setState(() {});
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
        DocumentSnapshot<Map<String, dynamic>> todoDoc =
        todoSnapshot.docs.first as DocumentSnapshot<Map<String, dynamic>>;
        // Delete the document
        await todoCollection.doc(todoDoc.id).delete();
      }
    } catch (error) {
      print('Error deleting todo item: $error');
      // Handle the error, e.g., show a message to the user
    }

    print('updating page');
    setState(() {});
  }

  // ignore: no_leading_underscores_for_local_identifiers
  void _addToDoItem(String _title, String _description, DateTime? _expirationDate) {
    String _uid = Auth().currentUser!.uid;
    String _tid = Uuid().v4(); // Generate a unique ID

    FirebaseFirestore.instance.collection("ToDo").add({
      "title": _title,
      "descriptiom": _description,
      "toDoState": false,
      "toDoDate": _expirationDate,
      "uid": _uid,
      "tid": _tid
    });
  }

  void _showAddTaskOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BottomSlideInput(
          onSubmit: (taskName, taskDescription, taskDate) {
            if (kDebugMode) {
              print('Added task: $taskName, Description: $taskDescription, Date: $taskDate');
            }
            _addToDoItem(taskName, taskDescription, taskDate);
            Navigator.pop(context); // Close the BottomSlideInput
          },
        );
      },
    );
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
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      ]),
    );
  }
}