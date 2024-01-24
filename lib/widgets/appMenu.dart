import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/screens/tasksToDo.dart';
import 'package:flutter_todo_app/screens/completedTasksScreen.dart';
import 'package:flutter_todo_app/auth.dart';

class AppMenu extends StatelessWidget {
  const AppMenu({Key? key});

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _signOutButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: signOut,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.exit_to_app),
              SizedBox(width: 8),
              Text('Sign out'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(User? user) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
          ),
          SizedBox(width: 16), // Add horizontal spacing between the avatar and text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(
              user?.email ?? 'User Email',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(Auth().currentUser),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  title: const Text('Task To Do'),
                  leading: const Icon(Icons.playlist_add),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TaskToDo(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Completed Tasks'),
                  leading: const Icon(Icons.check_box),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CompletedTasksScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          _signOutButton(),
        ],
      ),
    );
  }
}
