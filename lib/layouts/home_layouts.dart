import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archive/archive_screen.dart';
import 'package:todo/modules/done/done_screen.dart';
import 'package:todo/modules/tasks/tasks_screen.dart';
import 'package:todo/shared/components.dart';
import 'package:todo/shared/constants.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';
import 'package:todo/styles/icon_broken.dart';

class HomeLayout extends  StatelessWidget {
  // int currentIndex=0;
  // Database database;

  var scaffoldKey=GlobalKey<ScaffoldState>();

  var formKey=GlobalKey<FormState>();

  var titleCont=TextEditingController();
  var timeCont=TextEditingController();
  var dateCont=TextEditingController();



  // List<Widget>screens=[
  //   TaskeScreen(),
  //   DoneScreen(),
  //   ArchiveScreen()
  // ];
  // List<String>titles=[
  //   'tasks',
  //   'done',
  //   'archives',
  //
  // ];


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context, state) {
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }

        },
        builder: (BuildContext context, state) {
          AppCubit cubit=AppCubit.get(context);
          return Scaffold(
            backgroundColor: Color(0xffffffff),
            key: scaffoldKey,
            appBar: AppBar(title: Text(AppCubit.get(context).titles[AppCubit.get(context).currentIndex],style: TextStyle(color: Colors.blueAccent,fontSize: 25),),elevation: 0.0,backgroundColor: Colors.transparent,),
            body: ConditionalBuilder(builder: (BuildContext context) =>cubit.screens[cubit.currentIndex],
              condition: true,
              fallback: (context)=>Center(child: CircularProgressIndicator()),

            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                // insertToDatabase();

                if(cubit.isBottomSheetShown)
                {
                  if(formKey.currentState.validate()){
                    cubit.insertToDatabase(title: titleCont.text, time: timeCont.text, date: dateCont.text);
                    // insertToDatabase(
                    //     title:titleCont.text ,
                    //     date: dateCont.text,
                    //     time:timeCont.text
                    //
                    // ).then((value) {
                    //   getFromDatabase(database).then((value) {
                    //     Navigator.pop(context);
                    //
                    //     // setState(() {
                    //     //   isBtnSheetShow=false;
                    //     //   addbtn=Icons.edit;
                    //     //   tasks=value;
                    //     //
                    //     //
                    //     // });
                    //     print(tasks);
                    //
                    //   });

                    //
                    // });
                  }
                }else{

                  scaffoldKey.currentState.showBottomSheet((context) => Form(
                    key: formKey,
                    child: Container(
                      padding: EdgeInsets.all(25),
                      color: Colors.grey[200],
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultFormField(prefix: Icons.title, label: 'Task Title', validate:
                              (value){
                            if(value.isEmpty){
                              return 'value is empty';
                            }return null;
                          }, controller: timeCont, type: TextInputType.text,),
                          SizedBox(height: 12,),

                          defaultFormField(prefix: Icons.timer_outlined, label: 'Task Time', validate:
                              (value){
                            if(value.isEmpty){
                              return 'time must not empty';
                            }return null;
                          }, controller: titleCont, type: TextInputType.datetime,onTap: (){
                            showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
                              titleCont.text=value.format(context).toString();
                              print(value.format(context));
                            });
                          }
                          ),
                          SizedBox(height: 12,),
                          defaultFormField(
                              prefix: IconBroken.Calendar, label: 'Date Time', validate:
                              (value){
                            if(value.isEmpty){
                              return 'data must not empty';
                            }return null;
                          }, controller: dateCont, type: TextInputType.datetime,onTap: (){
                            showDatePicker(context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.parse('2025-05-03')).then((value) {
                              dateCont.text=DateFormat.yMMMd().format(value);
                              print(DateFormat.yMMMd().format(value));


                            });

                          }
                          ),
                        ],
                      ),
                    ),
                  )

                  ).closed.then((value) {
                    // Navigator.pop(context);
                    // isBtnSheetShow=false;
                    // setState(() {
                    //   addbtn=Icons.edit;
                    // });
                    cubit.changeBottomSheetState(
                      isShow: false,
                      icon: Icons.edit,
                    );
                  });
                  // isBtnSheetShow=true ;
                  // setState(() {
                  //   addbtn=Icons.add;
                  //
                  // });
                  cubit.changeBottomSheetState(
                    isShow: true,
                    icon: Icons.add,
                  );
                }




              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index){
                // setState(() {
                //   currentIndex=index;
                AppCubit.get(context).changeIndex(index);
                //
                // });

                print(index);

              },
              items: [
                BottomNavigationBarItem(icon: Icon(IconBroken.Document),label: 'Tasks'),
                BottomNavigationBarItem(icon: Icon(Icons.check),label: 'Done'),
                BottomNavigationBarItem(icon: Icon(IconBroken.Calendar),label: 'Archived'),
              ],
            ),
          );
        },
      ),
    );
  }

}

