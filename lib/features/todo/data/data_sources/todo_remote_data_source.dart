import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:week_28/core/const/constants.dart';
import 'package:week_28/features/todo/data/models/todo_model.dart';

abstract class TodoRemoteDataSource {
  Stream<List<TodoModel>> getTodos();
  Future<void> addTodo(TodoModel todo);
  Future<void> updateTodo(TodoModel todo);
  Future<void> deleteTodo(String id);
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  TodoRemoteDataSourceImpl({required this.firestore, required this.auth});

  CollectionReference get _todoCollection {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception('User must be logged in to access todos');
    }
    return firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .collection(AppConstants.todosCollection);
  }

  @override
  Stream<List<TodoModel>> getTodos() {
    return _todoCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) =>
                TodoModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList();
    });
  }

  @override
  Future<void> addTodo(TodoModel todo) async {
    await _todoCollection.add(todo.toMap());
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
    await _todoCollection.doc(todo.id).update(todo.toMap());
  }

  @override
  Future<void> deleteTodo(String id) async {
    await _todoCollection.doc(id).delete();
  }
}
