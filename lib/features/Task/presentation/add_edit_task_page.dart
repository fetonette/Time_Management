import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:myapp/features/Task/domain/entities/Task.dart';
import 'package:myapp/features/Task/presentation/cubit/task_cubit.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: AddEditTaskPage(
          task: Task(
              id: '123',
              title: 'Activity',
              description: 'Review For Today',
              deadline: DateTime(2024, 11, 11),
              priority: 5,
              progress: 9),
        ),
      ),
    ),
  );
}

class AddEditTaskPage extends StatefulWidget {
  final Task? task;

  const AddEditTaskPage({super.key, this.task});

  @override
  State<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPerforming = false;

  @override
  Widget build(BuildContext context) {
    String appBarTitle = widget.task == null ? 'Add new task' : 'Edit task';
    String buttonLabel = widget.task == null ? 'Add Task' : 'Edit task';
    final initialValues = {
      'title': widget.task?.title,
      'description': widget.task?.description,
      'deadline': widget.task?.deadline,
      'priority': widget.task?.priority.toString(),
      'progress': widget.task?.progress.toString(),
    };

    return BlocListener<TaskCubit, TaskState>(
      listener: (context, state) {
        if (state is TaskAdded) {
          Navigator.pop(context, "Task Added");
        } else if (state is TaskLoadFailure) {
          final snackBar = SnackBar(
            content: Text(state.message),
            duration: const Duration(seconds: 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            _isPerforming = false;
          });
        } else if (state is TaskUpdated) {
          Navigator.pop(context, state.newTask);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
        ),
        body: Column(
          children: [
            Expanded(
                child: FormBuilder(
              key: _formKey,
              initialValue: initialValues,
              child: ListView(
                padding: EdgeInsets.all(8.0),
                children: [
                  FormBuilderTextField(
                    name: 'title',
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Title'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FormBuilderTextField(
                    name: 'description',
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Description'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FormBuilderDateTimePicker(
                    name: 'date',
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Date'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FormBuilderTextField(
                    name: 'priority',
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Priority'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FormBuilderTextField(
                    name: 'progress',
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Progress'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                ],
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isPerforming
                          ? null
                          : () {
                              bool isValid = _formKey.currentState!.validate();
                              final inputs =
                                  _formKey.currentState!.instantValue;

                              if (isValid) {
                                setState(() {
                                  _isPerforming = true;
                                });

                                final newTask = Task(
                                    id: widget.task?.id ?? "",
                                    title: inputs["title"],
                                    description: inputs["description"],
                                    deadline: inputs["deadline"],
                                    priority: inputs["priority"],
                                    progress: double.parse(inputs["progress"]));

                                if (widget.task == null) {
                                  context.read<TaskCubit>().createTask(newTask);
                                } else {
                                  context.read<TaskCubit>().updateTask(newTask);
                                }
                              }
                            },
                      child: _isPerforming
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(),
                            )
                          : Text(buttonLabel),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
