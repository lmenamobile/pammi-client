import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/Brand.dart';
import 'package:wawamko/src/Models/Product/Product.dart';
import 'package:wawamko/src/Providers/ConectionStatus.dart';
import 'package:wawamko/src/Providers/ProfileProvider.dart';
import 'package:wawamko/src/Providers/ProviderHome.dart';
import 'package:wawamko/src/Providers/ProviderProducts.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Providers/ProviderShopCart.dart';
import 'package:wawamko/src/UI/Home/Brands/BrandsPage.dart';
import 'package:wawamko/src/UI/Home/Categories/ProductCategoryPage.dart';
import 'package:wawamko/src/UI/Home/SearchProduct/SearchProductHome.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/ShopCart/ShopCartPage.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/config/theme/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/UI/MenuLeft/DrawerMenu.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/features/feature_home/presentation/widgets/section_banners_slider.dart';
import 'package:wawamko/src/features/feature_home/presentation/widgets/section_departments_widget.dart';
import '../../../../Providers/ProviderChat.dart';
import '../../../../Providers/SocketService.dart';
import '../../../../UI/Chat/ChatPage.dart';
import '../../../../UI/Home/Products/DetailProductPage.dart';
import '../../../../UI/Home/Widgets.dart';
import '../../../feature_views_shared/domain/domain.dart';
import '../../../feature_views_shared/presentation/presentation.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final searchController = TextEditingController();
  RefreshController _refreshHome = RefreshController(initialRefresh: false);
  RefreshController _refreshCategories =
      RefreshController(initialRefresh: false);
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  late ProviderSettings providerSettings;
  late ProviderHome providerHome;
  late ProfileProvider profileProvider;
  late ProviderProducts providerProducts;
  late ProviderShopCart providerShopCart;
  late DepartmentProvider departmentProvider;
  late BannersProvider bannersProvider;
  SharePreference prefs = SharePreference();
  ConnectionAdmin connectionStatus = ConnectionAdmin.getInstance();
  late ProviderChat providerChat;
  late SocketService socketService;

  @override
  void initState() {
    super.initState();

    _initializeProviders();
    connectionStatus.initialize('www.google.com');
    _initializeCountry();
    profileProvider.user?.photoUrl = prefs.photoUser;
    _initializeVersion();
  }

  /*
    getBrands(); ------ getProductsMoreSelled();
   */

  void _initializeProviders() {
    departmentProvider  = Provider.of<DepartmentProvider>(context, listen: false);
    bannersProvider     = Provider.of<BannersProvider>(context, listen: false);
    providerSettings = Provider.of<ProviderSettings>(context, listen: false);
    providerHome = Provider.of<ProviderHome>(context, listen: false);
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    providerHome.clearProviderHome();
  }

  Future<void> _initializeVersion() async {
    try {
      prefs.versionApp = await utils.getVersion();
      providerHome.version = "v${prefs.versionApp}";
    } catch (e) {
      print('Error obteniendo la versión: $e');
    }
  }

  void _initializeCountry() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (prefs.countryIdUser != "") {
        departmentProvider.loadDepartments();

      } else {
        selectCountryUserNotLogin();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
    providerHome = Provider.of<ProviderHome>(context);
    providerShopCart = Provider.of<ProviderShopCart>(context);
    providerProducts = Provider.of<ProviderProducts>(context);
    providerChat = Provider.of<ProviderChat>(context);
    socketService = Provider.of<SocketService>(context);
    departmentProvider = Provider.of<DepartmentProvider>(context);
    connectionStatus.connectionListen.listen((value) {
      providerSettings.hasConnection = value;
    });
    return Scaffold(
      key: _drawerKey,
      drawer: DrawerMenuPage(
        rollOverActive: Constants.menuHome,
      ),
      backgroundColor: AppColors.white,
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return;
          final result = await utils.startCustomAlertMessage(
              context,
              Strings.sessionClose,
              "Assets/images/ic_sign_off.png",
              Strings.closeAppText,
              () => Navigator.pop(context, true),
              () => Navigator.pop(context, false));
          if (result == true) {
            Navigator.pop(context);
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              Container(color: Colors.white, child: _body(context)),
              // Botón flotante 1
              Positioned(
                bottom: 16.0,
                right: 16.0,
                child: btnFloating(openWhatsapp, "ic_whatsapp.svg"),
              ),
              // Botón flotante 2
              Visibility(
                visible: prefs.dataUser != "0",
                child: Positioned(
                  bottom: 76.0,
                  right: 16.0,
                  child: btnFloating(openChatAdmin, "ic_logo_pamii.svg"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 37),
          decoration: BoxDecoration(color: AppColors.redDot),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Center(
                        child: Image(
                          image: AssetImage("Assets/images/ic_menu.png"),
                        ),
                      ),
                    ),
                    onTap: () => _drawerKey.currentState!.openDrawer(),
                  ),
                  Image(
                    height: 20,
                    image: AssetImage("Assets/images/ic_logo.png"),
                  ),
                  GestureDetector(
                    child: Stack(
                      children: [
                        Container(
                          width: 30,
                          child: Image(
                            image: AssetImage("Assets/images/ic_car.png"),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Visibility(
                            visible: providerShopCart.totalProductsCart != "0"
                                ? true
                                : false,
                            child: CircleAvatar(
                              radius: 6,
                              backgroundColor: Colors.white,
                              child: Text(
                                providerShopCart.totalProductsCart,
                                style: TextStyle(
                                    fontSize: 8, color: AppColors.redTour),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    onTap: () => Navigator.push(
                        context,
                        customPageTransition(ShopCartPage(),
                            PageTransitionType.rightToLeftWithFade)),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              boxSearchNextPage(searchController, openPageSearch)
            ],
          ),
        ),
        Expanded(
          child: SmartRefresher(
            controller: _refreshHome,
            enablePullDown: true,
            header: headerRefresh(),
            footer: footerRefreshCustom(),
            onRefresh: _pullToRefresh,
            child: providerSettings.hasConnection
                ? SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                       SectionBannersSlider(
                           indexBanner: bannersProvider.indexBanner,
                           banners: bannersProvider.banners,
                           updateBannerIndex: bannersProvider.updateBannerIndex),
                        const SizedBox(height: 30),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: SectionDepartmentsWidget(
                              departments: departmentProvider.homeDepartments,
                              openCategories: () => openDepartmentCategory,
                            )),
                        const SizedBox(height: 55),
                        sectionsBrands(),
                        const SizedBox(height: 55),
                      ],
                    ),
                  )
                : notConnectionInternet(),
          ),
        ),
      ],
    );
  }

  Widget sectionsBrands() {
    return providerHome.ltsBrands.isEmpty
        ? Container()
        : Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          Strings.ourOfficialBrands,
                          style: TextStyle(
                              fontSize: 24,
                              fontFamily: Strings.fontBold,
                              color: AppColors.blueSplash),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () => openAllBrands(),
                        child: Text(
                          Strings.moreAll,
                          style: TextStyle(
                              color: AppColors.blue,
                              fontSize: 15,
                              fontFamily: Strings.fontMedium),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 22),
                Container(
                    height: 110,
                    padding: EdgeInsets.only(left: 30),
                    child: listItemsBrands()),
              ],
            ),
          );
  }



  Widget sectionBestSellers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            Strings.discoverThe,
            style: TextStyle(
                fontSize: 16,
                fontFamily: Strings.fontRegular,
                color: AppColors.gray15),
          ),
        ),
        SizedBox(
          height: 6,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strings.mostSelledProducts,
                style: TextStyle(
                    fontSize: 22,
                    fontFamily: Strings.fontBold,
                    color: AppColors.blueSplash),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
            padding: EdgeInsets.only(left: 30),
            height: 260,
            child: listBestSellers()),
      ],
    );
  }

  Widget listItemsBrands() {
    return ListView.builder(
      itemCount: providerHome!.ltsBrands.length > 6
          ? 6
          : providerHome!.ltsBrands.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (_, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: InkWell(
              onTap: () => openProductsByBrand(providerHome!.ltsBrands[index]),
              child: itemBrand(providerHome!.ltsBrands[index])),
        );
      },
    );
  }

  Widget listBestSellers() {
    return ListView.builder(
      itemCount: providerHome?.ltsMostSelledProducts.length ?? 0,
      scrollDirection: Axis.horizontal,
      itemBuilder: (_, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
              onTap: () =>
                  openDetailProduct(providerHome!.ltsMostSelledProducts[index]),
              child: itemProduct(providerHome!.ltsMostSelledProducts[index])),
        );
      },
    );
  }

  openProductsByBrand(Brand brand) {
    Navigator.push(
        context,
        customPageTransition(ProductCategoryPage(idBrand: brand.id.toString()),
            PageTransitionType.rightToLeftWithFade));
  }

  openAllBrands() {
    Navigator.push(
        context,
        customPageTransition(
            BrandsPage(), PageTransitionType.rightToLeftWithFade));
  }

  openDetailProduct(Product product) {
    String? color = product.references[0].color;
    if (product.references[0].images?.length != 0) {
      if (color != null && color.startsWith('#') && color.length >= 6) {
        providerProducts?.imageReferenceProductSelected =
            product.references[0].images?[0].url ?? "";
        providerProducts?.limitedQuantityError = false;
        Navigator.push(
            context,
            customPageTransition(DetailProductPage(product: product),
                PageTransitionType.rightToLeftWithFade));
      }
    }
  }

  openDepartmentCategory(Department department) {
    if (department.id == 0) {
      Navigator.push(
          context,
          customPageTransition(DepartmentCategoriesPage(),
              PageTransitionType.rightToLeftWithFade));
    } else {
      //Navigator.push(context,customPageTransition(SubCategoryPage(category: category,),PageTransitionType.rightToLeftWithFade));
    }
  }

  openPageSearch() {
    FocusScope.of(context).unfocus();
    if (searchController.text.isNotEmpty) {
      Navigator.push(
          context,
          customPageTransition(
              SearchProductHome(
                textSearch: searchController.text,
              ),
              PageTransitionType.rightToLeftWithFade));
    }
  }



  void _pullToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    providerHome.ltsBrands.clear();
    providerHome.ltsBanners.clear();
    providerHome.ltsBannersOffer.clear();
    providerHome.ltsMostSelledProducts.clear();
    departmentProvider.loadDepartments();
    getProductsMoreSelled();
    _refreshHome.refreshCompleted();
  }

/* TODO for refactor code
 getBrands() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callHome = providerHome!.getBrands("0");
        await callHome.then((list) {
          getBanners();
        }, onError: (error) {
          getBanners();
          //utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }*/

/* TODO for refactor code
 getBanners() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callHome = providerHome!.getBannersGeneral("0");
        await callHome.then((list) {
          getBannersOffer();
        }, onError: (error) {
          // utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }*/

/*  TODO for refactor code
getBannersOffer() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callHome = providerHome!.getBannersOffer("0");
        await callHome.then((list) {}, onError: (error) {
          //utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }*/

  getProductsMoreSelled() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callHome = providerHome!.getProductsMostSelled();
        await callHome.then((list) {}, onError: (error) {});
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  selectCountryUserNotLogin() async {
    bool state = await openSelectCountry(context);
    if (state) {
      departmentProvider.loadDepartments();
    } else {
      utils.showSnackBar(context, Strings.selectCountry);
    }
  }

  void openWhatsapp() {
    utils.openWhatsapp(
        context: context,
        text: Strings.helloHelp,
        number: Constants.numberWhatsapp);
  }

  void openChatAdmin() {
    getRoomSupport(context);
  }

  getRoomSupport(BuildContext context) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callChat = providerChat.getRomAdmin();
        await callChat.then((id) async {
          if (socketService.serverStatus != ServerStatus.Online) {
            socketService.connectSocket(Constants.typeAdmin, id, "");
          }
          Navigator.push(
              context,
              customPageTransition(
                  ChatPage(
                      roomId: id,
                      typeChat: Constants.typeAdmin,
                      imageProfile: Constants.profileAdmin,
                      fromPush: false),
                  PageTransitionType.rightToLeftWithFade));
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}
