import 'package:flutter/material.dart';
import 'package:flutter_sec10_api/services/auth.dart';
import 'package:flutter_sec10_api/views/get_all_task.dart';
import 'package:flutter_sec10_api/views/profile.dart';
import 'package:flutter_sec10_api/views/register.dart';
import 'package:provider/provider.dart';

import '../provider/user_token_provider.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Column(children: [
        TextField(controller: emailController,),
        TextField(controller: passwordController,),
        isLoading ?Center(child: CircularProgressIndicator(),)
            :ElevatedButton(onPressed: ()async{
              try{
                isLoading = true;
                setState(() {});
                await AuthSerives().loginUser(
                    email: emailController.text,
                    password: passwordController.text)
                    .then((userData)async{
                      userProvider.setToken(userData.token.toString());
                      await AuthSerives().getProfile(
                        userData.token.toString()
                      ).then((val){
                        isLoading = false;
                        setState(() {});
                        showDialog(context: context, builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Login Successfully"),
                            actions: [
                              TextButton(onPressed: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> GetAllTask()));
                              }, child: Text("Okay"))
                            ],);
                        }, );
                      });
                });
              }catch(e){
                isLoading = false;
                setState(() {});
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(e.toString())));
              }
        }, child: Text("Login")),
        ElevatedButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> Register()));
        }, child: Text("Register"))
      ],),
    );
  }
}
