import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:myapp/features/StudySession/domain/entities/studysession.dart';
import 'package:myapp/features/StudySession/presentation/cubit/study_session_cubit.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: AddEditStudysessionPage(
          studysession: StudySession(
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

class AddEditStudysessionPage extends StatefulWidget {
  final StudySession? studysession;

  const AddEditStudysessionPage({super.key, this.studysession});

  @override
  State<AddEditStudysessionPage> createState() =>
      _AddEditStudysessionPageState();
}

class _AddEditStudysessionPageState extends State<AddEditStudysessionPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPerforming = false;

  @override
  Widget build(BuildContext context) {
    String appBarTitle = widget.studysession == null? "Add new Study Session"
        : "Edit Study Session";
    String buttonLabel = widget.studysession == null
        ? "Add Study Session"
        : "Edit Study Session";
    final initialValues = {
      'subject': widget.studysession?.subject,
      'startTime': widget.studysession?.startTime,
      'duration': widget.studysession?.duration,
      'goals': widget.studysession?.goals,
    };

    return BlocListener<StudySessionCubit, StudySessionState>(
      listener: (context, state) {
        if (state is StudySessionLoaded) {
          Navigator.pop(context, "Study session added successfully");
        } else if (state is StudySessionError) {
          final snackBar = SnackBar(
            content: Text(state.message),
            duration: const Duration(seconds: 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            _isPerforming = false;
          });
        } else if (state is StudySessionUpdated) {
          Navigator.pop(context, state.newStudySession);
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
                    name: 'subject',
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'subject'),
                    keyboardType: TextInputType.text,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FormBuilderDateTimePicker(
                    name: 'startTime',
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Start Time'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FormBuilderTextField(
                    name: 'duration',
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Duration'),
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FormBuilderTextField(
                    name: 'goals',
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Goals'),
                    keyboardType: TextInputType.text,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(
                    height: 16,
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
                          child: const Text("Cancel"))),
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

                                final newStudySession = StudySession(
                                    id: widget.studysession?.id ?? "",
                                    subject: inputs['subject'],
                                    startTime: inputs['startTime'],
                                    duration: inputs['duration'],
                                    goals: inputs['goals']);

                                if (widget.studysession == null) {
                                  context
                                      .read<StudySessionCubit>()
                                      .createSession(newStudySession);
                                } else {
                                  context
                                      .read<StudySessionCubit>()
                                      .updateSession(newStudySession);
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
