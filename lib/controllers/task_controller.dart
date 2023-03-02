import 'package:get/get.dart';
import 'package:sqlite_project/Db/db_helper.dart';
import 'package:sqlite_project/models/task_model.dart';

class TaskController extends GetxController{

  @override
  void onReady() {
    getTasks();
    super.onReady();
  }
var taskList=<TaskModel>[].obs;
  
  Future<int> addTask({required TaskModel model})async{
   return await DbHelper.insert(model);
  }

  void getTasks() async{
    List<Map<String,dynamic>> tasks = await DbHelper.query();
    taskList.assignAll(tasks.map((data) {
      return new TaskModel.fromJson(data);
    }).toList());

  }

  void delete(TaskModel? model){
    DbHelper.delete(model!);
  }

  void maskTaskCompleted(int id)async{
    await DbHelper.update(id);
  }
}