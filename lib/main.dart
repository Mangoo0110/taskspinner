import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taskspinner/core/helpers/dekhao.dart';
import 'package:taskspinner/core/services/app_services.dart';
import 'app/ui/pages/app.dart';
import 'core/features/settings/presentation/notifiers/settings_data_provider.dart';
import 'init_dependencies.dart';
import 'utils/themes/themes.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ),
  );
   SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
  await getApplicationDocumentsDirectory().then((docDir) async {
    Hive.init(docDir.path);

    await initDependencies().then((value) async {
      runApp(const MyApp());
    });
  });
  
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _cnt = 0;
  ThemeMode _themeMode = AppServices.settingsDataProvider.currentSetting.themeMode;
  PrimaryColorMode _primaryColorMode = AppServices.settingsDataProvider.currentSetting.primaryColorMode;

  @override
  void didChangeDependencies() {

    AppServices.settingsDataProvider.addListener(() {
      dekhao("appearence changed. calling setState()");
      if (mounted && context.mounted && (_themeMode != AppServices.settingsDataProvider.currentSetting.themeMode || _primaryColorMode != AppServices.settingsDataProvider.currentSetting.primaryColorMode)) {
        _themeMode = AppServices.settingsDataProvider.currentSetting.themeMode;
        _primaryColorMode = AppServices.settingsDataProvider.currentSetting.primaryColorMode;
        setState(() {});
      }
    });
    super.didChangeDependencies();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _cnt++;
    dekhao("App building... $_cnt times");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Spinner',
      theme: AppTheme().lightTheme,
      darkTheme: AppTheme().darkTheme,
      themeMode: AppServices.settingsDataProvider.currentSetting.themeMode,
      home: const SpinnerTaskApp(),
    );
  }
}
