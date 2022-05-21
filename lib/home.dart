import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'db/db_provider.dart';
import 'model/task_model.dart';

class MyToDoApp extends StatefulWidget {
  const MyToDoApp({Key? key}) : super(key: key);

  @override
  State<MyToDoApp> createState() => _MyToDoAppState();
}

class _MyToDoAppState extends State<MyToDoApp> {
  Color backGroundColor = Color.fromARGB(255, 14, 10, 78);

  TextEditingController inputController = TextEditingController();
  String newTaskText = "";
  getTasks() async {
    final tasks = await DBProvider.dataBase.getTask();
    print(tasks);
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: backGroundColor,
        title: Text("My to do list !"),
      ),
      backgroundColor: backGroundColor,
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getTasks(),
              builder: (_, taskData) {
                switch (taskData.connectionState) {
                  case ConnectionState.waiting:
                    {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  case ConnectionState.done:
                    {
                      if (taskData.data != Null) {
                        return Padding(
                          padding: EdgeInsets.all(9.0),
                          child: ListView.builder(
                            //itemCount: taskData.data.length,
                            itemBuilder: (context, index) {
                              String task =
                                  taskData.data[index]['task'].toString();
                              String day = DateTime.parse(
                                      taskData.data[index]['creationDate'])
                                  .day
                                  .toString();
                              return Card(
                                  color: Color.fromARGB(255, 19, 15, 83),
                                  child: InkWell(
                                    child: Row(
                                      children: [
                                        Container(
                                          color: Color.fromARGB(
                                              255, 188, 131, 241),
                                          margin: EdgeInsets.only(right: 11.0),
                                          padding: EdgeInsets.all(11.0),
                                          child: Text(day,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.0)),
                                        ),
                                        Expanded(
                                          child: Text(
                                            task,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.0),
                                          ),
                                        )
                                      ],
                                    ),
                                  ));
                            },
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(
                            "You have no tasks",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                    }
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(9.0),
            decoration: BoxDecoration(color: Color.fromARGB(255, 61, 140, 206)),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: inputController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "New Task...",
                    ),
                  ),
                ),
                SizedBox(
                  width: 9.0,
                ),
                FlatButton.icon(
                  onPressed: () {
                    setState(() {
                      newTaskText = inputController.text.toString();
                      inputController.text = "";
                    });
                    Task newTask = Task(
                        task: newTaskText, dateTime: DateTime.now(), id: null);
                    DBProvider.dataBase.addNewTask(newTask);
                  },
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Add Task",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Color.fromARGB(255, 188, 131, 241),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
