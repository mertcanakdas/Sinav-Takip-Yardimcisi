import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gunsayaci/announcement/announcement_main.dart';
import 'package:gunsayaci/exams/presentation/pages/exam_screen.dart';
import 'package:gunsayaci/exams/presentation/pages/new_exam_screen.dart';
import 'package:gunsayaci/tasks/presentation/pages/new_task_screen.dart';
import 'package:gunsayaci/tasks/presentation/pages/tasks_screen.dart';
import 'package:gunsayaci/tasks/presentation/pages/update_task_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:timezone/data/latest.dart' as tz;

// Proje 1'e ait importlar
import 'package:gunsayaci/routes/app_router.dart';
import 'package:gunsayaci/bloc_state_observer.dart';
import 'package:gunsayaci/routes/pages.dart';
import 'package:gunsayaci/tasks/data/local/data_sources/tasks_data_provider.dart';
import 'package:gunsayaci/tasks/data/repository/task_repository.dart';
import 'package:gunsayaci/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:gunsayaci/utils/color_palette.dart';

// Proje 2'ye ait importlar
import 'package:gunsayaci/locator.dart';
import 'package:gunsayaci/pages/create_page.dart';
import 'package:gunsayaci/pages/home_page.dart';
import 'package:gunsayaci/pages/settings_page.dart';
import 'package:gunsayaci/services/functions/notification_helper.dart';
import 'package:gunsayaci/services/providers/home_provider.dart';
import 'package:gunsayaci/services/providers/settings_provider.dart';
import 'package:gunsayaci/utils/colors.dart';

// Proje 3'e ait importlar
import 'package:gunsayaci/exams/data/local/data_sources/exam_data_provider.dart';
import 'package:gunsayaci/exams/data/repository/exam_repository.dart';
import 'package:gunsayaci/exams/presentation/bloc/exam_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Proje 2: Timezone ve Bildirim Başlatma
  tz.initializeTimeZones();
  await NotificationHelper.initialize();

  // Proje 2: EasyLocalization Başlatma
  await EasyLocalization.ensureInitialized();

  // Proje 2: Dependency Injection Setup
  setupLocator();

  // Proje 1 ve 3 için Bloc ve SharedPreferences başlatma
  Bloc.observer = BlocStateOberver();
  SharedPreferences preferences = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        // Proje 2 için Providers
        ChangeNotifierProvider<HomeProvider>(
          create: (context) => locator.get<HomeProvider>(),
        ),
        ChangeNotifierProvider<SettingsProvider>(
          create: (context) => locator.get<SettingsProvider>(),
        ),
        // Proje 1 için Task Repository ve Bloc
        RepositoryProvider<TaskRepository>(
          create: (context) => TaskRepository(
            taskDataProvider: TaskDataProvider(preferences),
          ),
        ),
        BlocProvider<TasksBloc>(
          create: (context) => TasksBloc(
            context.read<TaskRepository>(),
          ),
        ),
        // Proje 3 için Exam Repository ve Bloc
        RepositoryProvider<ExamRepository>(
          create: (context) => ExamRepository(
            examDataProvider: ExamDataProvider(preferences),
          ),
        ),
        BlocProvider<ExamBloc>(
          create: (context) => ExamBloc(
            context.read<ExamRepository>(),
          ),
        ),
      ],
      child: EasyLocalization(
        supportedLocales: const [
          Locale("en"),
          Locale("tr"),
          Locale("ar"),
          Locale("az"),
          Locale("es"),
          Locale("fr"),
          Locale("hi"),
          Locale("ja"),
          Locale("ur"),
          Locale("pt"),
          Locale("ru"),
        ],
        path: "assets/translations",
        fallbackLocale: const Locale("tr"),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Merged Project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Sora',
        scaffoldBackgroundColor: KColors.baseColor,
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
        useMaterial3: true,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: '/',
      onGenerateRoute: onGenerateRoute,
      routes: {
        // Proje 2: Sayfalar
        '/': (context) => const HomePage(),
        '/create': (context) => const CreatePage(),
        //'/settings': (context) => const SettingsPage(),

        // Proje 1: Task modülü sayfaları
        '/tasks': (context) => const TasksScreen(),
        '/NewTaskScreen': (context) => const NewTaskScreen(),


        // Proje 3: Exam modülü sayfaları
        '/exams': (context) => const ExamScreen(),
        '/NewExamScreen': (context) => const NewExamScreen(),

        '/announcements': (context) =>  AnnouncementMainPage(),
        "/settings": (context) => const SettingsPage(),
      },
      builder: EasyLoading.init(),
    );
  }
}
