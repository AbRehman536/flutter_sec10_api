import 'package:flutter/material.dart';
import 'package:flutter_sec10_api/models/taskListing.dart';
import 'package:flutter_sec10_api/services/task.dart';
import 'package:flutter_sec10_api/views/update_task.dart';
import 'package:provider/provider.dart';

import '../provider/user_token_provider.dart';

class GetInCompletedTask extends StatelessWidget {
  const GetInCompletedTask({super.key});

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Get InCompleted Task"),
      ),
      body: FutureProvider.value(
        value: TaskServices().getInCompletedTask(userProvider.getToken().toString()),
        initialData: [TaskListingModel()],
        builder: (context, child){
          TaskListingModel taskListingModel =context.watch<TaskListingModel>();
          return ListView.builder(itemBuilder: (BuildContext context, int index) {
            return taskListingModel.tasks == null ?
            Center(child: Text("No Data Found"),):
            ListTile(
              leading: Icon(Icons.task),
              title: Text(taskListingModel.tasks![index].description.toString()),
            );
          },);
        },
      ),
    );
  }
}
