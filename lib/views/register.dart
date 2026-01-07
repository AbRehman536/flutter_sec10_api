import 'package:flutter/material.dart';
import 'package:flutter_sec10_api/services/auth.dart';
import 'package:flutter_sec10_api/views/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Register"),
      ),
      body: Column(children: [
        TextField(controller: nameController,),
        TextField(controller: emailController,),
        TextField(controller: passwordController,),
        isLoading ? Center(child: CircularProgressIndicator(),)
            :ElevatedButton(onPressed: ()async{
              try{
                isLoading = true;
                setState(() {});
                await AuthSerives().registerUser(
                    name: nameController.text,
                    email: emailController.text,
                    password: passwordController.text)
                    .then((value){
                  isLoading = false;
                  setState(() {});
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          title: Text("Register Successfully"),
                          actions: [
                            TextButton(onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> Login()));
                            }, child: Text("Okay"))
                          ],);
                      });
                });
              }catch(e){
                isLoading = false;
                setState(() {});
                ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.toString())));

              }
        }, child: Text("Register"))
      ],),
    );
  }
}
