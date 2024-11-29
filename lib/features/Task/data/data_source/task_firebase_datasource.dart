import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/core/errors/exceptions.dart';
import 'package:myapp/features/Task/data/data_source/task_remote_datasource.dart';
import 'package:myapp/features/Task/data/models/task_model.dart';
import 'package:myapp/features/Task/domain/entities/Task.dart' as myapptask;

class TaskFirebaseDatasource implements TaskRemoteDataSource {
  final FirebaseFirestore _firestore;

  TaskFirebaseDatasource(this._firestore);

  @override
  Future<void> createTask(myapptask.Task task) async {
    try {
      final taskDocRef = _firestore.collection('tasks').doc();
      final taskModel = TaskModel(
        id: taskDocRef.id,
        title: task.title,
        description: task.description,
        deadline: task.deadline,
        priority: task.priority,
        progress: task.progress,
      );
      await taskDocRef.set(taskModel.toMap());
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Something went wrong', statusCode: e.code);
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Something went wrong', statusCode: e.code);
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<List<myapptask.Task>> getAllTasks({
    DateTime? deadline,
    int? priority,
    String? subject,
  }) async {
    try {
      final querySnapshot = await _firestore
        .collection('tasks')
        .orderBy('deadline', descending: true)
        .get();
      return querySnapshot.docs.map((doc) {
        // Log the document data for debugging
        print('Document data: ${doc.data()}'); // Debugging line
        return myapptask.Task(
          id: doc['id'],
          title: doc['title'],
          description: doc['description'],
          deadline: DateTime.parse(doc['deadline']),
          priority: doc['priority'],
          progress: doc['progress'],
        );
      }).toList();
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}'); // Log Firebase exception
      throw APIException(
          message: e.message ?? 'Something went wrong', statusCode: e.code);
    } catch (e) {
      print('General Exception: ${e.toString()}'); // Log general exception
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> updateTask(myapptask.Task task) async {
    final taskModel = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      deadline: task.deadline,
      priority: task.priority,
      progress: task.progress,
    );

    try {
      await _firestore
          .collection('tasks')
          .doc(task.id)
          .update(taskModel.toMap());
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        throw APIException(message: 'Task not found', statusCode: e.code);
      }
      throw APIException(
          message: e.message ?? 'Something went wrong', statusCode: e.code);
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }
}
