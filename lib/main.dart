import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'app/ui/pages/app.dart';
import 'init_dependencies.dart';
import 'utils/themes/themes.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await getApplicationDocumentsDirectory().then((docDir) async {
    Hive.init(docDir.path);

    await initDependencies().then((value) async {
      runApp(const MyApp());
    });
  });
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SpinnerTaskApp(),
    );
  }
}
