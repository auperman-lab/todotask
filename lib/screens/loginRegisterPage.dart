import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_todo_app/constants/colors.dart';

import '../auth.dart';
import 'home.dart';

class LoginPage extends StatefulWidget{
  static const String routeName = "/login";
  const LoginPage({Key? key}) : super();

  @override
  State<LoginPage> createState() => _LoginPageState();


}

class _LoginPageState extends State<LoginPage>{
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword(BuildContext context) async{
    try {
      await Auth().signInWithEmailAndPassword(email: _controllerEmail.text, password: _controllerPassword.text);
      Navigator.pushReplacementNamed(context , Home.routeName);


    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword(BuildContext context) async{
    try {
      await Auth().createUserWithEmailAndPassword(email: _controllerEmail.text, password: _controllerPassword.text);
      Navigator.pushReplacementNamed(context , Home.routeName);


    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> googleSignIn(BuildContext context) async{
    try{
      await Auth().signInWithGoogle(context);
      Navigator.pushReplacementNamed(context , Home.routeName);

    } on FirebaseAuthException catch (e){
      errorMessage = e.message;
    }

  }



  Widget _title(){
    return const Text('TI-225 To Do App');
  }

  Widget googleSignInButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        await googleSignIn(context);
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 60,
        height: 60,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/google.svg',
                height: 25,
                width: 25,
              ),
              const SizedBox(
                width: 15,
              ),
              const Text(
                'Connect with Google',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }




  Widget _entryField(
      String title,
      TextEditingController controller){
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _errorMessage(){
    return Text(errorMessage == '' ? '': 'Humm ? $errorMessage');
  }

  Widget _submitButton(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5, // Set the elevation value for the shadow
        ),
        onPressed: isLogin ?
            () async {
            await signInWithEmailAndPassword(context);
        }
            : () async {
            await createUserWithEmailAndPassword(context);
        },
        child: Text(
            isLogin ? 'Login': 'Register',
            style: const TextStyle(
              color: tdBlack,
            ),

        ),


    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
        onPressed: () {
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: Text(
            isLogin ? 'Register instead': 'Login instead',
            style: const TextStyle(
            color: tdBlack,
          ),
        )

    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 10),
            googleSignInButton(context),
            const SizedBox(height: 10),
            const Text('or'),
            const SizedBox(height: 20),
            _entryField('Email', _controllerEmail),
            _entryField('Password', _controllerPassword),
            _errorMessage(),
            _submitButton(context),
            _loginOrRegisterButton()
          ],
        ),
      )
    );
  }

}