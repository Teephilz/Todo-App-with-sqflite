import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sqlite_project/add_task_page.dart';
import 'package:sqlite_project/controllers/task_controller.dart';
import 'package:sqlite_project/models/task_model.dart';
import 'package:sqlite_project/services/theme_service.dart';
import 'package:sqlite_project/services/theme_service.dart';
import 'package:get/get.dart';
import 'package:sqlite_project/theme.dart';
import 'package:sqlite_project/widget/button.dart';
import 'package:sqlite_project/widget/task_tile.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate=DateTime.now();
 TaskController _taskController= Get.put(TaskController());

 @override
  void initState() {
    _taskController.getTasks();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Column(
        children: [
         _addTaskBar(),
          _addDateBar(),
          SizedBox(height: 10,),
          _showTasks()
        ],
      ),
    );
  }

  _addDateBar(){
    return
      Container(
        margin: EdgeInsets.only(left: 20, top: 20),
        child: DatePicker(
          DateTime.now(),
          height: 100,
          width: 80,
          initialSelectedDate: DateTime.now(),
          selectionColor: primaryClr,
          selectedTextColor: Colors.white,
          dateTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey
            ),
          ),
          dayTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey
            ),
          ),

          monthTextStyle:  GoogleFonts.lato(
              textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey
              )),
          onDateChange: (date){
            setState((){
              _selectedDate=date;
            });

          },

        ),
      );
  }
_addTaskBar(){
    return
  Container(
    margin: const EdgeInsets.only(left: 20,right: 20,top: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat.yMMMd().format(DateTime.now()),
                style: subHeadingStyle,),
              Text("Today",
                style: headingStyle,)
            ],
          ),
        ),
        MyButton(label:"+ Add Task", onTap: ()async{
         await Get.to(()=>AddTaskPage());
         _taskController.getTasks();
        })
      ],
    ),
  );
}
  _appBar(){
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
         ThemeService().switchTheme();
        },
        child: Get.isDarkMode?Icon(Icons.wb_sunny_outlined):  Icon(Icons.nightlight_round,
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
  _showTasks(){
   return Expanded(
       child: Obx((){
         return ListView.builder(
             itemBuilder: (context,index){
               TaskModel model= _taskController.taskList[index];


               if(model.repeat == "Daily"){
                 return AnimationConfiguration.staggeredList(
                   position: index,
                   child: SlideAnimation(
                     child: FadeInAnimation(
                       child: Row(
                           children: [
                           GestureDetector(
                           onTap: (){
                     _showBottomSheet(context,model);
                     },
                       child: TaskTile(model),
                     )

                       ],
                     ),
                   ),
                 ));
         };
             if(model.date== DateFormat.yMd().format(_selectedDate)){
               return AnimationConfiguration.staggeredList(
                   position: index,
                   child: SlideAnimation(
                     child: FadeInAnimation(
                       child: Row(
                         children: [
                           GestureDetector(
                             onTap: (){
                               _showBottomSheet(context,model);
                             },
                             child: TaskTile(model),
                           )


                         ],
                       ),
                     ),
                   ));
             }
             else{
               return Container();
             }},
         itemCount: _taskController.taskList.length,);
       })
   );
  }

  _showBottomSheet(BuildContext context,TaskModel? model){
   Get.bottomSheet(
     Container(
       padding: EdgeInsets.only(top:4),
       height:  model!.isCompleted==1 ?
       MediaQuery.of(context).size.height* 0.24:
       MediaQuery.of(context).size.height* 0.32,
       color: Get.isDarkMode? darkGreyColor:Colors.white,
       child: Column(
         children: [
           Container(
             height: 6,
             width: 120,
             decoration:
             BoxDecoration(
             borderRadius: BorderRadius.circular(10),
             color: Get.isDarkMode? Colors.grey[600]:Colors.grey[300]
             )),
          Spacer(),
          model.isCompleted==1? Container()
             :_bottomSheetButton(
                 label: "Task Completed",
                 onTap: (){
                   _taskController.maskTaskCompleted(model.id!);
                   _taskController.getTasks();
                   Get.back();
                 },
                 clr: primaryClr,
                 context: context
             ),
           _bottomSheetButton(
               label: "Delete Task",
               onTap: (){
                 _taskController.delete(model);
                 _taskController.getTasks();
                 Get.back();
               },
               clr: Colors.red[300]!,
               context: context

           ),
           SizedBox(
             height: 15,
           ),

           _bottomSheetButton(
             isClose: true,
               label: "Close",
               onTap: (){
                 Get.back();
               },
               clr: Colors.white,
               context: context


           ),
         ],
       ),
     )
   );
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    required BuildContext context,
    bool isClose= false

}){
   return GestureDetector(
     onTap: onTap,
     child: Container(
       margin: const EdgeInsets.symmetric(vertical: 4),
       height: 55,
       width: MediaQuery.of(context).size.width*0.9,
       decoration: BoxDecoration(
         border: Border.all(
           width: 2,
           color: isClose== true?Get.isDarkMode?Colors.grey[600]!:Colors.grey[300]!:clr
         ),
         borderRadius: BorderRadius.circular(20),
         color: isClose== true?Colors.transparent:clr
       ),
       child: Center(child: Text(label,
         style: isClose== true? titleStyle:titleStyle.copyWith(color:Colors.white),)),

     ),

   );
  }
}

