import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tikodo_app/services/api_service.dart';
import 'package:tikodo_app/services/shared_service.dart';

import '../models/todo_model.dart';

class TikoDoPage extends StatefulWidget {
  const TikoDoPage({Key? key}) : super(key: key);

  @override
  State<TikoDoPage> createState() => _TikoDoPageState();
}

class _TikoDoPageState extends State<TikoDoPage> {
  List<Todo> todos = <Todo>[];
  GlobalKey<FormState> addTodoForm = GlobalKey<FormState>();
  final TextEditingController todoDescriptionController =
      TextEditingController();

  /// This method is called when the user removes a todo.
  void onDismissedTodo(int index) {
    setState(() {
      todos.removeWhere((todo) => todo.id == index);
    });
  }

  /// This method is called when the user updates the status of a todo.
  void onUpdatedTodo(Todo todo) {
    var updatedTodo = {
      'id': todo.id,
      'description': todo.description,
      'done': !todo.done
    };
    setState(() {
      todos[todo.id] = updatedTodo as Todo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: HexColor("#FEFEFE"),
      appBar: AppBar(
        backgroundColor: HexColor("#FEFEFE"),
        elevation: 0,
        actions: [
          Builder(
            builder: (context) => _logoutAction(context),
          ),
        ],
      ),
      body: _todoList(),
      floatingActionButton: Builder(
        builder: (context) => _addTodoButton(context),
      ),
    );
  }

  Widget _logoutAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: IconButton(
          onPressed: () {
            SharedService.logout(context);
          },
          icon: Icon(
            semanticLabel: "Logout",
            Icons.logout_rounded,
            size: 25,
            color: HexColor("#B5140E"),
          )),
    );
  }

  Widget _addTodoButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return _addTodoPopup(context);
            });
      },
      backgroundColor: HexColor("#B5140E"),
      tooltip: 'Add a todo',
      child: Icon(
        Icons.add,
        color: HexColor("#F1CAB4"),
      ),
    );
  }

  Widget _todoList() {
    return FutureBuilder<List<Todo>>(
      future: APIService.getTodos(),
      builder: (BuildContext context, AsyncSnapshot<List<Todo>> model) {
        if (!model.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        todos = model.data ?? <Todo>[];

        return Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                color: HexColor("#FEFEFE"),
                border: Border.all(
                  color: HexColor("#FEFEFE"),
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(
                20,
                0,
                20,
                5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Welcome to tikoDo",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: HexColor("#B5140E"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'REMAINING TASKS ',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          color: HexColor("#3B3836"),
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          const TextSpan(text: "    "),
                          TextSpan(
                            text:
                                "${todos.where((todo) => todo.done != true).length}/${todos.length}",
                            style: TextStyle(
                              color: HexColor("#C06A5E"),
                              fontSize: 18,
                            ),
                          ),
                        ]),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: todos.isEmpty
                        ? Text(
                            "You dont have any more tasks.",
                            style: TextStyle(
                              color: HexColor("#3B3836"),
                            ),
                          )
                        : ListView.separated(
                            separatorBuilder: (context, index) => Divider(
                              color: HexColor("#FEFEFE"),
                              height: 10,
                              thickness: 10,
                            ),
                            shrinkWrap: true,
                            itemCount: todos.length,
                            itemBuilder: (context, index) {
                              return _todo(todos[index]);
                            },
                          ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  Widget _todo(todo) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            left: BorderSide(
          color: HexColor("#B5140E"),
          width: 4,
        )),
      ),
      child: Dismissible(
        key: Key(todo.description),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            return await showDialog(
              context: context,
              builder: (context) => SimpleDialog(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 20,
                  ),
                  backgroundColor: HexColor("#FEFEFE"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: Text(
                    "Delete task",
                    style: TextStyle(
                      fontSize: 20,
                      color: HexColor("#B5140E"),
                    ),
                  ),
                  children: [
                    Text(
                      "Are you sure you want to delete this task?",
                      style: TextStyle(
                        color: HexColor("#3B3836"),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3.5,
                          height: 50,
                          child: TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        HexColor("#C06A5E"))),
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: HexColor("#FEFEFE")),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3.5,
                          height: 50,
                          child: TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        HexColor("#B5140E"))),
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: Text(
                              "Delete",
                              style: TextStyle(color: HexColor("#FEFEFE")),
                            ),
                          ),
                        )
                      ],
                    ),
                  ]),
            );
          }
          return false;
        },
        background: Container(
          padding: const EdgeInsets.only(right: 10),
          alignment: Alignment.centerRight,
          color: HexColor("#B5140E"),
          child: Text(
            "DELETE",
            style: TextStyle(
              color: HexColor("#FEFEFE"),
              fontSize: 18,
            ),
          ),
        ),
        onDismissed: (direction) async {
          await APIService.deleteTodo(todo.id);
          onDismissedTodo(todo.id);
        },
        child: ListTile(
          hoverColor: HexColor("#FEFEFE"),
          tileColor: HexColor("#FEFEFE"),
          onTap: () async {
            await APIService.updateTodo(todo);
            setState(() {});
          },
          leading: SizedBox(
            height: 18,
            width: 18,
            child: todo.done
                ? Icon(
                    Icons.check_circle,
                    color: HexColor("#8c92ac"),
                  )
                : Icon(
                    Icons.circle_outlined,
                    color: HexColor("#C06A5E"),
                  ),
          ),
          title: Text(
            todo.description,
            style: TextStyle(
              decoration:
                  todo.done ? TextDecoration.lineThrough : TextDecoration.none,
              fontSize: 18,
              color: todo.done ? HexColor("#8c92ac") : HexColor("#3B3836"),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _addTodoPopup(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 20,
      ),
      backgroundColor: HexColor("#FEFEFE"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Row(
        children: [
          Text(
            "Add task",
            style: TextStyle(
              fontSize: 20,
              color: HexColor("#B5140E"),
            ),
          ),
          const Divider(),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.cancel,
              color: HexColor("#B5140E"),
              size: 28,
            ),
          ),
        ],
      ),
      children: [
        Form(
          key: addTodoForm,
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              if (value.length >= 30) {
                return 'Text must be shorter than 30 characters';
              }
              return null;
            },
            controller: todoDescriptionController,
            autofocus: true,
            style: TextStyle(
              fontSize: 18,
              height: 1,
              color: HexColor("#3B3836"),
            ),
            decoration: InputDecoration(
              fillColor: HexColor("#f3f3f4"),
              filled: true,
              hintText: "eg. Buy milk",
              hintStyle: TextStyle(
                color: HexColor("#8c92ac"),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: HexColor("#B5140E"), width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: HexColor("#f3f3f4"), width: 2.0),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: TextButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(HexColor("#B5140E"))),
            onPressed: () async {
              if (addTodoForm.currentState!.validate()) {
                var navigator = Navigator.pop(context);
                await APIService.addTodo(todoDescriptionController.text);
                navigator;
                todoDescriptionController.clear();
                await APIService.getTodos();
                setState(() {});
              }
            },
            child: Text(
              "Add",
              style: TextStyle(color: HexColor("#FEFEFE")),
            ),
          ),
        )
      ],
    );
  }
}
