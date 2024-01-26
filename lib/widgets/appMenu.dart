
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants/colors.dart';
import 'package:flutter_todo_app/screens/home.dart';
import 'package:flutter_todo_app/screens/tasksToDo.dart';
import 'package:flutter_todo_app/screens/completedTasksScreen.dart';
import 'package:flutter_todo_app/auth.dart';

import '../screens/loginRegisterPage.dart';

class AppMenu extends StatelessWidget {
  const AppMenu({Key? key});

  Future<void> signOut(BuildContext context) async {
    await Auth().signOut();
    Navigator.pushReplacementNamed(context , LoginPage.routeName);
  }

  Widget _signOutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await signOut(context);
      },

      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: EdgeInsets.zero, // Remove padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), // Set border radius to 0 for rectangular shape
        ),
        minimumSize: Size(150, 50), // Set your desired width and height

      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.exit_to_app,
            color:tdWhite,
          ),
          SizedBox(width: 8),
          Text(
            'Sign out',
            style: TextStyle(
              color: tdWhite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(User? user) {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: tdYellow,
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: tdWhite,
          ),
          SizedBox(width: 16), // Add horizontal spacing between the avatar and text
          Flexible( // Use Flexible to enable text wrapping
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.email ?? 'User Email',
                  style: const TextStyle(
                    color: tdWhite,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
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
                  title: const Text('All Tasks'),
                  leading: const Icon(Icons.list),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Home(),
                      ),
                    );
                  },
                ),
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
          _signOutButton(context),
        ],
      ),
    );
  }
}
