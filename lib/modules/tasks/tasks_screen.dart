import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/constants.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class TaskeScreen extends  StatelessWidget {


  @override
  Widget build(BuildContext context) {
     return
       BlocConsumer<AppCubit,AppStates>(
         listener: (BuildContext context, state) {  },
         builder: (BuildContext context, state) {
           var tasks=AppCubit.get(context).newTasks;
           return ConditionalBuilder(
             builder: (BuildContext context) =>ListView.separated(itemBuilder:
                 (context,index)=>dufaultTasksItem(context: context,model: tasks[index]),
                 separatorBuilder: (context,index)=>Container(),
                 itemCount: tasks.length),
             condition: tasks.length>0,
                 fallback:(context)=>Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     Text(' Tasks is Empty',style: TextStyle(color: Colors.grey,fontSize: 20),),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Image(image: NetworkImage('https://image.freepik.com/free-vector/woman-ticking-off-tasks-checklist-illustration_179970-474.jpg'),),
                     ),
                   ],
                 )

         );

         },
       );

  }
  Widget dufaultTasksItem({Map model,context}){
    return Dismissible(
      key: Key((model['id'].toString())),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Row(
               crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Color(0xffc7d0eb),
                          borderRadius: BorderRadius.circular(8)
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('${model['date']}'),
                      )),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xfffaf5e7),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        width: MediaQuery.of(context).size.width*.6,
                        height: 120,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${model['time']}',style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),),
                              Text('${model['title']}',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
            Row(
              children: [
                IconButton(onPressed: (){
                  AppCubit.get(context).updateData(status: 'done', id:model['id']);
                },icon:Icon(Icons.check_circle_outline),color: Colors.green,),
                IconButton(
                    onPressed: (){
                      AppCubit.get(context).updateData(status: 'archive', id:model['id']);
                    },
                    icon:Icon(Icons.archive_outlined)),
              ],
            )
          ],
        ),
      ),
      onDismissed: (direction){
        AppCubit.get(context).deleteData(id: model['id']);

      },
    );
  }
}
