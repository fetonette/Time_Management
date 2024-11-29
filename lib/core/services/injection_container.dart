import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:myapp/features/StudySession/data/data_source/studysession_firebase_datasource.dart';
import 'package:myapp/features/StudySession/data/data_source/studysession_remote_datasource.dart';
import 'package:myapp/features/StudySession/data/repository_impl/studysession_repo_impl.dart';
import 'package:myapp/features/StudySession/domain/repositories/studysession_repo.dart';
import 'package:myapp/features/StudySession/domain/usecases/create_studysession.dart';
import 'package:myapp/features/StudySession/domain/usecases/delete_studysession.dart';
import 'package:myapp/features/StudySession/domain/usecases/read_studysession.dart';
import 'package:myapp/features/StudySession/domain/usecases/update_studysession.dart';
import 'package:myapp/features/StudySession/presentation/cubit/study_session_cubit.dart';
import 'package:myapp/features/Task/data/data_source/task_firebase_datasource.dart';
import 'package:myapp/features/Task/data/data_source/task_remote_datasource.dart';
import 'package:myapp/features/Task/data/repository_impl/task_repo_impl.dart';
import 'package:myapp/features/Task/domain/repositories/Task_repo.dart';
import 'package:myapp/features/Task/domain/usecases/create_task.dart';
import 'package:myapp/features/Task/domain/usecases/delete_task.dart';
import 'package:myapp/features/Task/domain/usecases/read_task.dart';
import 'package:myapp/features/Task/domain/usecases/update_task.dart';
import 'package:myapp/features/Task/presentation/cubit/task_cubit.dart';

final servicelocator = GetIt.instance;

// manage dependencies

Future<void> init() async {
  // Feature 1: Task
  //application layer
  servicelocator.registerCachedFactory(() => TaskCubit(
      createTaskUseCase: servicelocator(),
      readTaskUseCase: servicelocator(),
      updateTaskUseCase: servicelocator(),
      deleteTaskUseCase: servicelocator()));

  //domain layer
  servicelocator
      .registerLazySingleton(() => CreateTask(repository: servicelocator()));
  servicelocator
      .registerLazySingleton(() => GetTasks(repository: servicelocator()));

   servicelocator
      .registerLazySingleton(() => UpdateTask(repository: servicelocator()));
   servicelocator
      .registerLazySingleton(() => DeleteTask(repository: servicelocator()));

 //data layer
  servicelocator
      .registerLazySingleton<TaskRepository>(
        () => TaskRepositoryImplementation(servicelocator()));
  servicelocator
      .registerLazySingleton<TaskRemoteDataSource>(
        () => TaskFirebaseDatasource(servicelocator()));
  servicelocator
      .registerLazySingleton(
        () => FirebaseFirestore.instance);


// Feature 2: Study Session
  //application layer
  servicelocator.registerCachedFactory(() =>StudySessionCubit(
    createStudysession: servicelocator(),
    deleteStudySession:servicelocator(),
    getStudySessions: servicelocator(),
    updateStudySession: servicelocator()));

  //domain layer
  servicelocator
      .registerLazySingleton(() => CreateStudysession(repository: servicelocator()));
  servicelocator
      .registerLazySingleton(() => DeleteStudySession(repository: servicelocator()));

   servicelocator
      .registerLazySingleton(() => GetStudySessions(repository: servicelocator()));
   servicelocator
      .registerLazySingleton(() => UpdateStudySession(repository: servicelocator()));

 //data layer
  servicelocator
      .registerLazySingleton<StudySessionRepository>(
        () => StudySessionRepositoryImplementation(servicelocator()));
  servicelocator
      .registerLazySingleton<StudySessionRemoteDataSource>(
        () => StudySessionFirebaseRemoteDatasource(servicelocator()));

  

}
