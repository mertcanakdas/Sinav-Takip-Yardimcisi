import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gunsayaci/routes/app_router.dart';
import 'package:gunsayaci/bloc_state_observer.dart';
import 'package:gunsayaci/routes/pages.dart';
import 'package:gunsayaci/exams/data/local/data_sources/exam_data_provider.dart';
import 'package:gunsayaci/exams/data/repository/exam_repository.dart';
import 'package:gunsayaci/exams/presentation/bloc/exam_bloc.dart';
import 'package:gunsayaci/utils/color_palette.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = BlocStateOberver();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  runApp(MyApp(
    preferences: preferences,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences preferences;

  const MyApp({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
        create: (context) =>
            ExamRepository(examDataProvider: ExamDataProvider(preferences)),
        child: BlocProvider(
            create: (context) => ExamBloc(context.read<ExamRepository>()),
            child: MaterialApp(
              title: 'Exam Manager',
              debugShowCheckedModeBanner: false,
              initialRoute: Pages.exam,
              onGenerateRoute: onGenerateRoute,
              theme: ThemeData(
                fontFamily: 'Sora',
                visualDensity: VisualDensity.adaptivePlatformDensity,
                canvasColor: Colors.transparent,
                colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
                useMaterial3: true,
              ),
            )));
  }
}
