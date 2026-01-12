import 'package:flutter/material.dart';
import 'package:flutter_sec10_api/models/taskListing.dart';
import 'package:flutter_sec10_api/services/task.dart';
import 'package:flutter_sec10_api/views/completed_task.dart';
import 'package:flutter_sec10_api/views/inCompleted_task.dart';
import 'package:flutter_sec10_api/views/profile.dart';
import 'package:flutter_sec10_api/views/update_task.dart';
import 'package:provider/provider.dart';

import '../provider/user_token_provider.dart';

class GetAllTask extends StatelessWidget {
  const GetAllTask({super.key});

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Get All Task"),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> GetCompletedTask()));
          }, icon: Icon(Icons.circle)),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> GetInCompletedTask()));
          }, icon: Icon(Icons.incomplete_circle)),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Profile()));
          }, icon: Icon(Icons.person)),
        ],
      ),
      body: FutureProvider.value(
          value: TaskServices().getAllTask(userProvider.getToken().toString()),
          initialData: [TaskListingModel()],
      builder: (context, child){
            TaskListingModel taskListingModel =context.watch<TaskListingModel>();
            return ListView.builder(itemBuilder: (BuildContext context, int index) {
              return taskListingModel.tasks == null ?
              Center(child: Text("No Data Found"),):
              ListTile(
                leading: Icon(Icons.task),
                title: Text(taskListingModel.tasks![index].description.toString()),
                trailing: Row(children: [
                  IconButton(onPressed: () async{
                    try{
                      await TaskServices().deleteTask(
                          token: userProvider.getToken().toString(),
                          taskID: taskListingModel.tasks![index].id.toString());
                    }catch(e){
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  }, icon: Icon(Icons.delete)),
                  IconButton(onPressed: ()async{
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateTask(model: taskListingModel.tasks![index])));
                  }, icon: Icon(Icons.edit))
                ],),
              );
            },);
      },
      ),
    );
  }
}
