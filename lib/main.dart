import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/services/injection_container.dart';
import 'package:myapp/features/StudySession/presentation/cubit/study_session_cubit.dart';
import 'package:myapp/features/StudySession/presentation/view_all_studysession_page.dart';
import 'package:myapp/features/Task/presentation/view_all_tasks.dart';
import 'package:myapp/firebase_options.dart';
import 'features/Task/presentation/cubit/task_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          BlocProvider(
            create: (context) => servicelocator<StudySessionCubit>(),
            child: const ViewAllStudysessionPage(),
          ),
          BlocProvider(
            create: (context) => servicelocator<TaskCubit>(),
            child: const ViewAllTasksPage(),
          ),
          const Center(
            child: Text('Insert Profile Page here'),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          debugPrint("current index is $index");
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book), label: "StudySession"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Tasks"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
