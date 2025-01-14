import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Providers/ProviderShopCart.dart';
import 'package:wawamko/src/Providers/ProviderUser.dart';
import 'package:wawamko/src/Providers/PushNotificationService.dart';
import 'package:wawamko/src/Providers/SocketService.dart';
import 'package:wawamko/src/Providers/SupportProvider.dart';
import 'package:wawamko/src/Providers/pqrs_provider.dart';
import 'package:wawamko/src/UI/Home/ProductsCatalogSeller/ProductsCatalog.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/features/feature_filter_right/presentation/presentation.dart';
import 'package:wawamko/src/features/feature_products/feature_products.dart';



import 'src/Providers/ProfileProvider.dart';
import 'src/Providers/Onboarding.dart';
import 'src/UI/Onboarding/Tour/Splash.dart';
import 'src/Utils/Strings.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'src/config/config.dart';
import 'src/features/feature_department_categories/feature_department_categories.dart';
import 'src/features/feature_views_shared/feature_views_shared.dart';


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
  await Environment.initEnvironment();
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = SharePreference();
  await prefs.initPrefs();
  await NotificationsPushServices.initializeApp();

  final departmentDatasource = DepartmentDatasourceImpl();
  final departmentRepository = DepartmentRepositoryImpl(remoteDataSource: departmentDatasource);

  final bannerDatasource = BannerDatasourceImpl();
  final bannerRepository = BannerRepositoryImpl(remoteDataSource: bannerDatasource);

  final brandDatasource = BrandDatasourceImpl();
  final brandRepository = BrandRepositoryImpl(remoteDataSource: brandDatasource);

  final categoryDatasource = CategoryDatasourceImpl();
  final categoryRepository = CategoryRepositoryImpl(remoteDatasource: categoryDatasource);

  final subCategoryDatasource = SubCategoryDatasourceImpl();
  final subCategoryRepository = SubCategoryRepositoryImpl(remoteDatasource: subCategoryDatasource);

  final productsDatasource = ProductDatasourceImpl();
  final productsRepository = ProductRepositoryImpl(remoteDataSource: productsDatasource);


  runApp(MyApp(
    departmentRepository: departmentRepository,
    bannerRepository: bannerRepository,
    brandRepository: brandRepository,
    categoryRepository: categoryRepository,
    subCategoryRepository: subCategoryRepository,
    productRepository: productsRepository,
  ));
}


launchLocalNotification(String payloadData){

}

class MyApp extends StatefulWidget {
    final DepartmentRepository departmentRepository;
    final BannerRepository bannerRepository;
    final BrandRepository brandRepository;
    final CategoryRepository categoryRepository;
    final SubCategoryRepository subCategoryRepository;
    final ProductRepository productRepository;

  const MyApp({super.key,
    required this.departmentRepository,
    required this.bannerRepository,
    required this.brandRepository,
    required this.categoryRepository,
    required this.subCategoryRepository,
    required this.productRepository});
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


  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: AppColors.redTour)
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => DepartmentProvider(repository: widget.departmentRepository)),
        ChangeNotifierProvider(create: (_) => BannersProvider(repository: widget.bannerRepository)),
        ChangeNotifierProvider(create: (_) => BrandsProvider(repository: widget.brandRepository)),
        ChangeNotifierProvider(create: (_) => CategoriesProvider(repository: widget.categoryRepository)),
        ChangeNotifierProvider(create: (_) => SubCategoriesProvider(subCategoryRepository: widget.subCategoryRepository)),
        ChangeNotifierProvider(create: (_) => ProductsProvider(repository: widget.productRepository)),
        ChangeNotifierProvider(create: (_) => FilterRightProvider()),
        ChangeNotifierProvider(create: (_)=> VariablesNotifyProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ProviderSettings()),
        ChangeNotifierProvider(create: (_) => ProviderHome()),
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
          primaryColor: AppColors.redTour,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }

}

