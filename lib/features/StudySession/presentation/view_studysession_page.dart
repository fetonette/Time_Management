import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/services/injection_container.dart';
import 'package:myapp/features/StudySession/domain/entities/studysession.dart';
import 'package:myapp/features/StudySession/presentation/cubit/add_edit_studysession_page.dart';
import 'package:myapp/features/StudySession/presentation/cubit/study_session_cubit.dart';
import 'package:myapp/features/StudySession/presentation/view_studysession_row.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ViewStudysessionPage(
          studySession: StudySession(
            id: '1',
            subject: 'Math',
            startTime: DateTime.now(),
            duration: 2,
            goals: 'Study for exam',
          ),
        ),
      ),
    ),
  );
}

class ViewStudysessionPage extends StatefulWidget {
  final StudySession studySession;

  const ViewStudysessionPage({
    super.key,
    required this.studySession,
  });

  @override
  State<ViewStudysessionPage> createState() => _ViewStudysessionState();
}

class _ViewStudysessionState extends State<ViewStudysessionPage> {
  late StudySession _currentStudySession;

  @override
  void initState() {
    super.initState();
    _currentStudySession = widget.studySession;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudySessionCubit, StudySessionState>(
      listener: (context, state) {
        if (state is StudySessionDeleted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.pop(context, "Study Session Deleted");
        } else if (state is StudySessionError) {
          final snackBar = SnackBar(
            content: Text(state.message),
            duration: const Duration(seconds: 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_currentStudySession.subject),
          actions: [
            IconButton(
                onPressed: () async {
                  final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) =>
                              servicelocator<StudySessionCubit>(),
                          child: AddEditStudysessionPage(
                            studysession: _currentStudySession,
                          ),
                        ),
                      ));

                  if (result.runtimeType == StudySession) {
                    setState(() {
                      _currentStudySession = result;
                    });
                  }
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  const snackBar = SnackBar(
                    content: Text("Deleting Study session..."),
                    duration: Duration(seconds: 9),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  context
                      .read<StudySessionCubit>()
                      .deleteSession(widget.studySession as String);
                },
                icon: const Icon(Icons.delete)),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            LabelValueRow(
                label: "Subject", value: _currentStudySession.subject),
            LabelValueRow(label: "Goal", value: _currentStudySession.goals),
            LabelValueRow(
                label: "Start Time", value: _currentStudySession.startTime),
            LabelValueRow(
                label: "Duration", value: _currentStudySession.duration),
          ],
        ),
      ),
    );
  }
}
