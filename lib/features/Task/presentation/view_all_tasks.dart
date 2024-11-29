import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/services/injection_container.dart';
import 'package:myapp/core/widgets/empty_state_list.dart';
import 'package:myapp/core/widgets/error_state_list.dart';
import 'package:myapp/core/widgets/loading_state_shimmer_list.dart';
import 'package:myapp/features/Task/presentation/add_edit_task_page.dart';
import 'package:myapp/features/Task/presentation/cubit/task_cubit.dart';
import 'package:myapp/features/Task/presentation/view_task_page.dart';

class ViewAllTasksPage extends StatefulWidget {
  const ViewAllTasksPage({super.key});

  @override
  State<ViewAllTasksPage> createState() => _ViewAllTasksPageState();
}

class _ViewAllTasksPageState extends State<ViewAllTasksPage> {
  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Tasks"),
            ),
            body: BlocBuilder<TaskCubit, TaskState>(
              builder: (context, state) {
                if (state is TaskLoadInProgress) {
                  debugPrint("BlocBuilder TaskLoadInProgress");
                  return const LoadingStateShimmerList();
                } else if (state is TaskLoadSuccess) {
                  return ListView.builder(
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      final currentTask = state.tasks[index];

                      return Card(
                        child: ListTile(
                          title: Text(currentTask.title),
                          subtitle: Text(currentTask.description),
                          onTap: () async {
                           final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) =>
                                        servicelocator<TaskCubit>(),
                                    child: ViewTaskPage(task: currentTask),
                                  ),
                                ));
                            context
                                .read<TaskCubit>()
                                .loadTasks(); // refresh the page

                            if (result.runtimeType == String) {
                              final snackBar = SnackBar(content: Text(result));
                               ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }


                          },
                        ),
                      );
                    },
                  );
                } else if (state is TaskLoadFailure) {
                  debugPrint("BlocBilder TaskLoadFailure");
                  return ErrorStateList(
                    imageAssetName: 'assets/images/mark.png',
                    errorMessage: state.message,
                    onRetry: () {
                      context.read<TaskCubit>().loadTasks();
                    },
                  );
                } else {
                  debugPrint("BlocBuilder else");
                  return const EmptyStateList(
                    imageAssetName: 'assets/images/folder.png',
                    title: 'Ooops... there are no tasks here',
                    description: "Tap the '+' button to add a new task",
                  );
                }
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => servicelocator<TaskCubit>(),
                        child: const AddEditTaskPage(),
                      ),
                    ));

                context
                    .read<TaskCubit>()
                    .loadTasks(); // refresh the view all task page

                if (result.runtimeType == String) {
                  final snackBar = SnackBar(content: Text(result));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: const Icon(Icons.add),
            ),
          );
        });
  }
}
