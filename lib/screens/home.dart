import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  final Auth _auth = Auth();
  User? user;

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Widget _title() {
    return const Text('firebase auth');
  }

  Widget _userUid() {
    return Text('${user?.email}');
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('sign out'),
    );
  }

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget._title(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget._userUid(),
          widget._signOutButton(),
        ],
      ),
    );
  }
}
