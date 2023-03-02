import 'package:sqflite/sqflite.dart';
import 'package:sqlite_project/models/task_model.dart';

class DbHelper{
  static Database? _db;
  static final int _version= 1;
  static final String _tableName= "tasks";

  static Future<void> initDb()async{
    if(_db!= null){
      return;
    }
    try{
      String _path= await getDatabasesPath() + "tasks.db";
      _db= await openDatabase(
        _path,
        version: _version,
        onCreate: (db,version){
          return db.execute(
            "CREATE TABLE $_tableName("
                "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "title STRING, note TEXT, date STRING, "
                "startTime STRING, endTime STRING, "
                "remind INTEGER, repeat STRING, "
                "color INTEGER, "
                "isCompleted INTEGER)"
          );
        }
      );
    } catch(e){
      print(e);
    }
  }

  static Future<int> insert(TaskModel? model) async{
    return await _db?.insert(_tableName, model!.toJson())?? 1;
  }


  static Future<List<Map<String, dynamic>>> query() async{
    return await _db!.query(_tableName);
  }

  static update(int id) async{
    return
  await  _db!.rawUpdate('''
    UPDATE tasks
    SET isCompleted = ?
    WHERE id= ?
    ''', [1,id]);
  }

  static delete(TaskModel? model) async{
  await _db!.delete(_tableName,where: 'id=?', whereArgs: [model!.id]);
  }

}