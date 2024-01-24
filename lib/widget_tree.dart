
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/auth.dart';
import 'package:flutter_todo_app/screens/home.dart';
import 'package:flutter_todo_app/screens/loginRegisterPage.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super();

  @override
  State<StatefulWidget> createState() => _WidgetTreeState();

}

class _WidgetTreeState extends State<WidgetTree>{

  @override
  Widget build(BuildContext context){
    return StreamBuilder(
      stream:  Auth().authStateChanges,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return Home();
        }else{
          return const LoginPage();
        }
      },

    );
  }
}