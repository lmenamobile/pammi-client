import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as inapWebView;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wawamko/src/Models/User.dart';

import 'package:wawamko/src/Providers/VariablesNotifyProvider.dart';
import 'package:wawamko/src/Providers/ProviderChat.dart';
import 'package:wawamko/src/Providers/ProviderCheckOut.dart';
import 'package:wawamko/src/Providers/ProviderClaimOrder.dart';
import 'package:wawamko/src/Providers/ProviderCustomerService.dart';
import 'package:wawamko/src/Providers/ProviderHome.dart';
import 'package:wawamko/src/Providers/ProviderOder.dart';
import 'package:wawamko/src/Providers/ProviderOffer.dart';
import 'package:wawamko/src/Providers/ProviderProducts.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Providers/ProviderShopCart.dart';
import 'package:wawamko/src/Providers/ProviderUser.dart';
import 'package:wawamko/src/Providers/PushNotificationService.dart';
import 'package:wawamko/src/Providers/SocketService.dart';
import 'package:wawamko/src/Providers/SupportProvider.dart';
import 'package:wawamko/src/Providers/UserProvider.dart';
import 'package:wawamko/src/Providers/pqrs_provider.dart';
import 'package:wawamko/src/UI/Home/HomePage.dart';
import 'package:wawamko/src/UI/Home/ProductsCatalogSeller/ProductsCatalog.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'src/Providers/ProfileProvider.dart';
import 'src/Providers/Onboarding.dart';
import 'src/UI/Onboarding/Tour/Splash.dart';
import 'src/Utils/Strings.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final BehaviorSubject<ReceivedNotificationVO> didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotificationVO>();
final BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();



class MyHttpOverrides extends HttpOverrides  {
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}


void main() async{
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
 // await Firebase.initializeApp();
  final prefs = SharePreference();
  await prefs.initPrefs();
  await NotificationsPushServices.initializeApp();


  var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_push');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int? id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotificationVO(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          launchLocalNotification(payload);
          debugPrint('notification payload: ' + payload);
        }
        selectNotificationSubject.add(payload!);
      });

  if (Platform.isAndroid) {
   // await inapWebView.AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    var swAvailable = await inapWebView.AndroidWebViewFeature.isFeatureSupported(
        inapWebView.AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await inapWebView.AndroidWebViewFeature.isFeatureSupported(
        inapWebView.AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      inapWebView.AndroidServiceWorkerController serviceWorkerController =
      inapWebView.AndroidServiceWorkerController.instance();

      await serviceWorkerController
          .setServiceWorkerClient(inapWebView.AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          print(request);
          return null;
        },
      ));
    }
  }


  runApp(MyApp());
}


launchLocalNotification(String payloadData){


  /*DataPayload? dataPayload;

  if(payloadData != ""){
    dataPayload = DataPayload.fromJson(jsonDecode(payloadData));
  }

  switch (dataPayload?.typeNotification){
    case 'opportunity':
    // FunctionsHelp().goToPushPage(context, DetailOpportunityPage(idOpportunity: int.parse()));
      break;
    case 'profile':
    //navigatorKey.currentState!.pushNamed('event');
      break;
    case 'room':

      if(dataPayload?.dataUser != null){
        if(dataPayload?.moduleId != ''){
          DatesBasicUser dates = DatesBasicUser(fullName: dataPayload?.dataUser?.fullname, photoUrl:  dataPayload?.dataUser?.photoUrl,userId:dataPayload?.dataUser?.id ?? '' );
          //chatProvider.roomId =moduleId;
          NotifContext.navigatorKey.currentState?.pushNamed('chat',arguments: {"withRoomId":true,"dataUser":dates,"fromPush":true,"roomId":int.parse(dataPayload?.moduleId ?? '0')});
          //navigatorKey.currentState?.pushNamed('chat',arguments: {"withRoomId":true,"dataUser":dates,"fromPush":true,"roomId":int.parse(dataPayload?.moduleId ?? '0')});


        }
      }



      break;
    default:
    // navigatorKey.currentState!.pushNamed('notifications');
      break;
  }*/
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    NotificationsPushServices.dataNotification.listen((event) {
      print("MyApp: ${event['isLocal']}");
      if(event['isLocal']){
        _showNotification(event['title'],event['description']);
      }else{
       // _launchNotification(event['module'],event['dataUser'] ,event['moduleId']);
      }
    });
  }

  void _showNotification(String title, String description) async {



    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        importance: Importance.max,
        priority: Priority.high);
    var iOSPlatformChannelSpecifics =
    const IOSNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true
    );
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        title,
        description,
        platformChannelSpecifics,
        payload:"");


  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: CustomColors.redTour)
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_)=> VariablesNotifyProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ProviderSettings()),
        ChangeNotifierProvider(create: (_) => ProviderHome()),
        ChangeNotifierProvider(create: (_) => ProviderProducts()),
        ChangeNotifierProvider(create: (_) => ProviderUser()),
        ChangeNotifierProvider(create: (_) => ProviderShopCart()),
        ChangeNotifierProvider(create: (_) => ProviderCheckOut()),
        ChangeNotifierProvider(create: (_) => ProviderOrder()),
        ChangeNotifierProvider(create: (_) => ProviderChat()),
        ChangeNotifierProvider(create: (_) => SocketService()),
        ChangeNotifierProvider(create: (_) => SupportProvider()),
        ChangeNotifierProvider(create: (_) => ProviderOffer()),
        ChangeNotifierProvider(create: (_) => ProviderClaimOrder()),
        ChangeNotifierProvider(create: (_) => ProviderCustomerService()),
        ChangeNotifierProvider(create: (_) => PQRSProvider()),
      ],
      child: MaterialApp(
        onGenerateRoute: (RouteSettings settings) {
          print(settings.name??"");
          // Si la ruta es un deep link
         if (settings.name!.isNotEmpty&&settings.name!="") {
           List<String> parts = settings.name.toString().split('/');
           String idSeller = parts.last;
           print(idSeller);
            return MaterialPageRoute(builder: (context) =>ProductsCatalog(idSeller: idSeller));
          }
          return null;
        },
        title: Strings.appName,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        navigatorKey: navigatorKey,
        supportedLocales: [
          const Locale('es'),
        ],
        debugShowCheckedModeBanner: false,
        initialRoute: 'splash',
        routes: <String,WidgetBuilder>{
          'splash':(_) => SplashPage(),
        },
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }

}

