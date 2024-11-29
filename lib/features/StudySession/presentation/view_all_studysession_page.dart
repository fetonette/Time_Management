import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/services/injection_container.dart';
import 'package:myapp/core/widgets/empty_state_list.dart';
import 'package:myapp/core/widgets/error_state_list.dart';
import 'package:myapp/core/widgets/loading_state_shimmer_list.dart';
import 'package:myapp/features/StudySession/presentation/cubit/add_edit_studysession_page.dart';
import 'package:myapp/features/StudySession/presentation/view_studysession_page.dart';
import 'cubit/study_session_cubit.dart';

class ViewAllStudysessionPage extends StatefulWidget {
  const ViewAllStudysessionPage({super.key});

  @override
  State<ViewAllStudysessionPage> createState() =>
      _ViewAllStudysessionPageState();
}

class _ViewAllStudysessionPageState extends State<ViewAllStudysessionPage> {
  @override
  void initState() {
    super.initState();
    context.read<StudySessionCubit>().fetchSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("StudySession"),
        ),
        body: BlocBuilder<StudySessionCubit, StudySessionState>(
          builder: (context, state) {
            if (state is StudySessionLoading) {
              return const LoadingStateShimmerList();
            } else if (state is StudySessionLoaded) {
              debugPrint("BlocBuilder StudySessionLoaded");
              if (state.sessions.isEmpty) {
                return const EmptyStateList(
                  imageAssetName: 'assets/images/mark.png',
                  title: 'Ooops...there are no study sessions here',
                  description: "Tap the '+' button to add a new study session",
                );
              }

              return ListView.builder(
                itemCount: state.sessions.length,
                itemBuilder: (context, index) {
                  final currentStudySession = state.sessions[index];

                  return Card(
                    child: ListTile(
                      title: Text(currentStudySession.subject),
                      subtitle: Text(currentStudySession.goals),
                      onTap: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) =>
                                    servicelocator<StudySessionCubit>(),
                                child: ViewStudysessionPage(
                                    studySession: currentStudySession),
                              ),
                            ));
                        context
                            .read<StudySessionCubit>()
                            .fetchSessions(); //refresh the page

                        if (result.runtimeType == String) {
                          final snackBar = SnackBar(
                            content: Text(result),
                            duration: const Duration(seconds: 2),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                    ),
                  );
                },
              );
            } else if (state is StudySessionError) {
              return ErrorStateList(
                imageAssetName: 'assets/images/mark.png',
                errorMessage: state.message,
                onRetry: () {
                  context.read<StudySessionCubit>().fetchSessions();
                },
              );
            } else {
              return const EmptyStateList(
                imageAssetName: 'assets/images/folder.png',
                title: 'Ooops...there are no study sessions here',
                description: "Tap the '+' button to add a new study session",
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
                    create: (context) => servicelocator<StudySessionCubit>(),
                    child: const AddEditStudysessionPage(),
                  ),
                ));
            context.read<StudySessionCubit>().fetchSessions(); // refresh

            if (result.runtimeType == String) {
              final snackBar = SnackBar(
                content: Text(result),
                duration: const Duration(seconds: 2),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          child: const Icon(Icons.add),
        ));
  }
}
