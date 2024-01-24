import 'package:flutter/material.dart';
import 'package:flutter_todo_app/screens/tasksToDo.dart';

import '../screens/completedTasksScreen.dart';
import '../screens/home.dart';

class AppMenu extends StatelessWidget {
  const AppMenu({Key? key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue, // Set your desired color
            ),
            child: Text('Menu Header'),
          ),
          ListTile(
            title: const Text('Task To Do'),
            leading: const Icon(Icons.playlist_add),
            onTap: () {
              // Handle Completed Tasks click
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TaskToDo(), // Instantiate the Home class
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Completed Tasks'),
            leading: const Icon(Icons.check_box),
            onTap: () {
              // Handle Completed Tasks click
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CompletedTasksScreen(),
                ),
              );
            },
          ),
          // Add more ListTile items as needed
        ],
      ),
    );
  }
}
