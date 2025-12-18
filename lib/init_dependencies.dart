import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:week_28/features/google_auth/data/data_source/google_auth_data_source.dart';
import 'package:week_28/features/google_auth/data/repositories/auth_repository_impl.dart';
import 'package:week_28/features/google_auth/domain/repositories/google_auth_repo.dart';
import 'package:week_28/features/google_auth/domain/usecases/sign_in_with_google.dart';
import 'package:week_28/features/google_auth/domain/usecases/get_current_user.dart';
import 'package:week_28/features/google_auth/domain/usecases/sign_out.dart';
import 'package:week_28/features/google_auth/presentation/bloc/auth_bloc.dart';
import 'package:week_28/features/todo/data/data_sources/todo_remote_data_source.dart';
import 'package:week_28/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:week_28/features/todo/domain/repositories/todo_repository.dart';
import 'package:week_28/features/todo/domain/usecases/add_todo.dart';
import 'package:week_28/features/todo/domain/usecases/delete_todo.dart';
import 'package:week_28/features/todo/domain/usecases/get_todos.dart';
import 'package:week_28/features/todo/domain/usecases/toggle_todo.dart';
import 'package:week_28/features/todo/presentation/bloc/todo_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initTodo();
}

void _initAuth() {
  // External
  serviceLocator.registerLazySingleton(() => FirebaseAuth.instance);
  serviceLocator.registerLazySingleton(() => FirebaseFirestore.instance);
  serviceLocator.registerLazySingleton(() => GoogleSignIn());

  // Datasource
  serviceLocator.registerFactory<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSource(
      auth: serviceLocator(),
      googleSignIn: serviceLocator(),
      firestore: serviceLocator(),
    ),
  );

  // Repository
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: serviceLocator()),
  );

  // Usecase
  serviceLocator.registerFactory(() => SignInWithGoogle(serviceLocator()));
  serviceLocator.registerFactory(() => GetCurrentUser(serviceLocator()));
  serviceLocator.registerFactory(() => SignOut(serviceLocator()));

  // Bloc
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      signInWithGoogle: serviceLocator(),
      getCurrentUser: serviceLocator(),
      signOut: serviceLocator(),
    ),
  );
}

void _initTodo() {
  // Datasource
  serviceLocator.registerFactory<TodoRemoteDataSource>(
    () => TodoRemoteDataSourceImpl(
      firestore: serviceLocator(),
      auth: serviceLocator(),
    ),
  );

  // Repository
  serviceLocator.registerFactory<TodoRepository>(
    () => TodoRepositoryImpl(remoteDataSource: serviceLocator()),
  );

  // Usecase
  serviceLocator.registerFactory(() => GetTodos(serviceLocator()));
  serviceLocator.registerFactory(() => AddTodo(serviceLocator()));
  serviceLocator.registerFactory(() => ToggleTodo(serviceLocator()));
  serviceLocator.registerFactory(() => DeleteTodo(serviceLocator()));

  // Bloc
  serviceLocator.registerFactory(
    () => TodoBloc(
      getTodos: serviceLocator(),
      addTodo: serviceLocator(),
      toggleTodo: serviceLocator(),
      deleteTodo: serviceLocator(),
    ),
  );
}
