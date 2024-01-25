import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../auth.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}) : super();

  @override
  State<LoginPage> createState() => _LoginPageState();



}

class _LoginPageState extends State<LoginPage>{
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async{
    try {
      await Auth().signInWithEailAndPassword(email: _controllerEmail.text, password: _controllerPassword.text);

    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async{
    try {
      await Auth().createuserWithEmailAndPassword(email: _controllerEmail.text, password: _controllerPassword.text);

    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> googleSignIn() async{
    try{
      await Auth().googleSignIn(context);
    } on FirebaseAuthException catch (e){
      errorMessage = e.message;
    }

  }

  Widget _title(){
    return const Text('firebase auth');
  }

  Widget buttonItem() {
    return InkWell(
      onTap: googleSignIn,
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
                'Continue with Google',
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

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: isLogin ? signInWithEmailAndPassword: createUserWithEmailAndPassword,
        child: Text(isLogin ? 'Login': 'Register'));
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
        onPressed: () {
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: Text(isLogin ? 'Register instead': 'Login instead'));
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
            buttonItem(),
            const SizedBox(height: 10),
            const Text('or'),
            const SizedBox(height: 20),
            _entryField('email', _controllerEmail),
            _entryField('password', _controllerPassword),
            _errorMessage(),
            _submitButton(),
            _loginOrRegisterButton()
          ],
        ),
      )
    );
  }

}