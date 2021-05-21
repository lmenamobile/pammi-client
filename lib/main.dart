import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:wawamko/src/Bloc/notifyVaribles.dart';
import 'package:wawamko/src/UI/HomePage.dart';
import 'package:wawamko/src/UI/VerificationCode.dart';
import 'package:wawamko/src/Utils/share_preference.dart';

import 'src/Providers/Onboarding.dart';
import 'src/UI/InterestCategoriesUser.dart';
import 'src/UI/Onboarding/Splash.dart';
import 'src/Utils/Strings.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = SharePreference();

  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> NotifyVariablesBloc()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
      ],
      child: MaterialApp(
        title: Strings.appName,
        debugShowCheckedModeBanner: false,
        initialRoute: 'splash',
        routes: <String,WidgetBuilder>{
          'splash':(_) => SplashPage(),
        },
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

