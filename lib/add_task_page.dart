import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqlite_project/controllers/task_controller.dart';
import 'package:sqlite_project/homepage.dart';
import 'package:sqlite_project/models/task_model.dart';
import 'package:sqlite_project/services/theme_service.dart';
import 'package:sqlite_project/theme.dart';
import 'package:sqlite_project/widget/button.dart';
import 'package:sqlite_project/widget/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController taskController= Get.put(TaskController());
  TextEditingController _titleController=TextEditingController();
  TextEditingController _noteController=TextEditingController();
  DateTime _selectedDate= DateTime.now();
  String _startTime= DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime="10:00 AM";
  int selectedRemind=5;
List<int> remindList=[
  5,
  10,
  15,
  20
];
  String selectedRepeat="None";
List<String> repeatList=[
  "None",
  "Daily",
  "Weekly",
  "Monthly"
];

int selectedColorIndex=0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child:
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add Task",
              style: headingStyle,),
              CustomTextField(
                title: "Title",
                hint: "Enter your title",
                controller: _titleController,

              ),
              CustomTextField(
                title: "Note",
                hint: "Enter your note",
                controller: _noteController,
              ),
              CustomTextField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: (){
                    _getDateFromUser();
                  },
                  icon: Icon(Icons.calendar_month_outlined,),
                ),
              ),

              Row(
                children: [
                  Expanded(
                      child: CustomTextField(
                          title: "Start Time",
                          hint:_startTime,
                          widget: IconButton(icon:Icon(Icons.watch_later_rounded),
                    onPressed: (){
                      getTime(context: context, isStartTime: true,
                        initialTime:TimeOfDay(hour: int.parse(_startTime.split(":")[0]),
                            minute:  int.parse(_startTime.split(":")[1].split(" ")[0])),

                      );
                    },),
                  )),
                  SizedBox(width: 12),
                  Expanded(
                      child:
                  CustomTextField(
                    title: "End Time",
                    hint: _endTime,
                      widget: IconButton(icon:Icon(Icons.watch_later_rounded),
                    onPressed: (){
                        getTime(context: context, isStartTime: false,
                          initialTime:TimeOfDay(hour: int.parse(_endTime.split(":")[0]),
                              minute:  int.parse(_endTime.split(":")[1].split(" ")[0])),

                        );

                    },),
                  ))
                ],
              ),
              CustomTextField(
                title: "Remind",
                hint: "$selectedRemind minutes early",
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down_rounded,),
                  iconSize: 32,
                  elevation: 4,
                  underline: Container(height: 0,),
                  onChanged: (val){
                    setState(() {
                      selectedRemind= int.parse(val!);
                    });
                  },
                  items: remindList.map((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                        child:Text(value.toString())
                    );
                  }).toList(),
                ),
              ),

              CustomTextField(
                title: "Repeat",
                hint: selectedRepeat,
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down_rounded,),
                  iconSize: 32,
                  elevation: 4,
                  underline: Container(height: 0,),
                  onChanged: (val){
                    setState(() {
                      selectedRepeat=val!;
                    });
                  },
                  items: repeatList.map((value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child:Text(value)
                    );
                  }).toList(),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 5.0, top: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _colorPallete(),
                    MyButton(label: "Create Task", onTap: (){
                      _validateText();
                    })
                  ],
                ),
              ),
            



            ],
          ),
        ),
      ),
    );
  }

  _appBar(BuildContext context){
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
        Get.back();
        },
        child:  Icon(Icons.arrow_back_ios_rounded,
          size: 20,
          color: Get.isDarkMode? Colors.white: Colors.black,),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage("images/task.png"),
        ),
        SizedBox(width: 20,)
      ],
    );
  }

  _colorPallete(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color",
          style: titleStyle,),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Wrap(
              children:
              List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        selectedColorIndex=index;
                      });
                    },
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: index==0? primaryClr: index==1? pinkClr:yellowClr,
                      child: selectedColorIndex==index? Icon(Icons.check,
                        color: Colors.white,):Container(),
                    ),
                  ),

                );
              })
          ),
        ),

      ],
    );
  }

  _getDateFromUser() async{
    DateTime? _pickedDate= await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2121));

    if(_pickedDate!=null){
      setState(() {
        _selectedDate= _pickedDate;
      });

    }
  }



getTime({
  required BuildContext context,
   String? title,
   TimeOfDay? initialTime,
   required bool isStartTime
}) async{

    TimeOfDay? time= await showTimePicker(
        initialEntryMode:TimePickerEntryMode.dial,
        context: context,
        initialTime: initialTime?? TimeOfDay.now(),
        helpText: isStartTime== true? "Select Start Time":"SelectEnd Time",
        builder: (context,Widget? child){
          return  MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!);
   });
    String formattedTime= time!.format(context);
    if(isStartTime == true){
      setState((){
        _startTime= formattedTime;
      });

    }
    else if(
    isStartTime==false
    ){
      setState((){
        _endTime= formattedTime;
      });
    }
 }

 _validateText()async{
    if(_titleController.text.isNotEmpty && _noteController.text.isNotEmpty){
    await  _addTaskToDB();
      Get.to(()=>HomePage());
    }
    else if(_titleController.text.isEmpty || _noteController.text.isEmpty){
      Get.snackbar("Error",
          "All fields are required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.redAccent,
        icon: Icon(Icons.error,
        color: Colors.redAccent,)
      );
    }
 }

 _addTaskToDB() async{
   int value= await taskController.addTask(
    model:
        TaskModel(
        title: _titleController.text,
        note: _noteController.text,
        isCompleted: 0,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        color: selectedColorIndex,
        remind: selectedRemind,
        repeat: selectedRepeat

    ));
    print("my id is" + " $value");
 }
}
