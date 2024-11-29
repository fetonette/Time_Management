import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/services/injection_container.dart';
import 'package:myapp/features/StudySession/presentation/view_studysession_row.dart';
import 'package:myapp/features/Task/domain/entities/Task.dart';
import 'package:myapp/features/Task/presentation/add_edit_task_page.dart';
import 'package:myapp/features/Task/presentation/cubit/task_cubit.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: ViewTaskPage(
              task: Task(
                  id: '123',
                  title: 'Activity',
                  description: 'Review For Today',
                  deadline: DateTime(2024, 11, 11),
                  priority: 5,
                  progress: 9))),
    ),
  );
}

class ViewTaskPage extends StatefulWidget {
  final Task task;

  const ViewTaskPage({
    super.key,
    required this.task,
  });

  @override
  State<ViewTaskPage> createState() => _ViewTaskPageState();
}

class _ViewTaskPageState extends State<ViewTaskPage> {
  late Task _currentTask;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskCubit, TaskState>(
      listener: (context, state) {
        if (state is TaskDeleted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.pop(context, "Task deleted");
        } else if (state is TaskLoadFailure) {
          final snackBar = SnackBar(
            content: Text(state.message),
            duration: const Duration(seconds: 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_currentTask.description),
          actions: [
            IconButton(
                onPressed: () async {
                  final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => servicelocator<TaskCubit>(),
                          child: AddEditTaskPage(
                            task: _currentTask,
                          ),
                        ),
                      ));

                  if (result.runtimeType == Task) {
                    //TODO:
                    setState(() {
                      _currentTask = result;
                    });
                  }
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  const snackBar = SnackBar(
                    content: Text("Deleting task..."),
                    duration: Duration(seconds: 9),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  context.read<TaskCubit>().deleteTask(widget.task as String);
                },
                icon: const Icon(Icons.delete))
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            LabelValueRow(label: 'Title', value: _currentTask.title),
            LabelValueRow(label: 'Deadline', value: _currentTask.deadline),
            LabelValueRow(
                label: 'Description', value: _currentTask.description),
            LabelValueRow(label: 'Priority', value: _currentTask.priority),
            LabelValueRow(label: 'Progress', value: _currentTask.progress),
          ],
        ),
      ),
    );
  }
}
