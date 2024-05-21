import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/Brand.dart';
import 'package:wawamko/src/Models/Category.dart';
import 'package:wawamko/src/Models/Product/Product.dart';
import 'package:wawamko/src/Providers/ConectionStatus.dart';
import 'package:wawamko/src/Providers/ProfileProvider.dart';
import 'package:wawamko/src/Providers/ProviderHome.dart';
import 'package:wawamko/src/Providers/ProviderProducts.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Providers/ProviderShopCart.dart';
import 'package:wawamko/src/UI/Home/Brands/BrandsPage.dart';
import 'package:wawamko/src/UI/Home/Categories/CategoriesPage.dart';
import 'package:wawamko/src/UI/Home/Categories/ProductCategoryPage.dart';
import 'package:wawamko/src/UI/Home/Categories/SubCategoryPage.dart';
import 'package:wawamko/src/UI/Home/SearchProduct/SearchProductHome.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/Highlights/HighlightsPage.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/ShopCart/ShopCartPage.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/UI/MenuLeft/DrawerMenu.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import '../../Providers/ProviderChat.dart';
import '../../Providers/SocketService.dart';
import '../Chat/ChatPage.dart';
import 'Products/DetailProductPage.dart';
import 'Widgets.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final searchController = TextEditingController();
  RefreshController _refreshHome = RefreshController(initialRefresh: false);
  RefreshController _refreshCategories = RefreshController(initialRefresh: false);
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  late ProviderSettings providerSettings;
  ProviderHome? providerHome;
  ProfileProvider? profileProvider;
  ProviderProducts? providerProducts;
  late ProviderShopCart  providerShopCart;
  SharePreference prefs = SharePreference();
  ConnectionAdmin connectionStatus = ConnectionAdmin.getInstance();
  late ProviderChat providerChat;
  late SocketService socketService;


  @override
  void initState() {
    providerSettings = Provider.of<ProviderSettings>(context, listen: false);
    providerHome = Provider.of<ProviderHome>(context, listen: false);
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    providerHome!.ltsBrands.clear();
    providerHome!.ltsBanners.clear();
    providerHome!.ltsBannersOffer.clear();
    providerSettings.ltsCategories.clear();
    providerHome!.ltsMostSelledProducts.clear();
    connectionStatus.initialize('www.google.com');
    if (prefs.countryIdUser != "0") {
      serviceGetCategories();
    } else {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        selectCountryUserNotLogin();
      });
    }
    profileProvider?.user?.photoUrl = prefs.photoUser;
    utils.getVersion().then((value) {
      providerHome!.version = "v" + value;
      print("VERSION ${providerHome!.version}");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
    providerHome = Provider.of<ProviderHome>(context);
    providerShopCart = Provider.of<ProviderShopCart>(context);
    providerProducts = Provider.of<ProviderProducts>(context);
    providerChat = Provider.of<ProviderChat>(context);
    socketService = Provider.of<SocketService>(context);
    connectionStatus.connectionListen.listen((value){
      providerSettings.hasConnection = value;
    });
    return Scaffold(
      key: _drawerKey,
      drawer: DrawerMenuPage(
        version:providerHome!.version,
        rollOverActive: Constants.menuHome,
      ),
      backgroundColor: CustomColors.white,
      body: WillPopScope(
        onWillPop:(()=> utils.startCustomAlertMessage(context, Strings.sessionClose,
            "Assets/images/ic_sign_off.png", Strings.closeAppText, ()=>
              Navigator.pop(context,true), ()=>Navigator.pop(context,false)).then((value) => value!)),
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                  color: Colors.white, child: _body(context)),
              // Botón flotante 1
              Positioned(
                bottom: 16.0,
                right: 16.0,
                child: btnFloating(openWhatsapp, "ic_whatsapp.svg"),
              ),
              // Botón flotante 2
              Visibility(
                visible:prefs.dataUser != "0",
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
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 37),
          decoration: BoxDecoration(
            color: CustomColors.redDot
          ),
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
                            visible: providerShopCart.totalProductsCart!="0"?true:false,
                            child: CircleAvatar(
                              radius: 6,
                              backgroundColor: Colors.white,
                              child: Text(
                                providerShopCart.totalProductsCart,
                                style: TextStyle(
                                    fontSize: 8,
                                    color: CustomColors.redTour
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    onTap: () => Navigator.push(
                        context, customPageTransition(ShopCartPage())),
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
            child: providerSettings.hasConnection?SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Visibility(
                    visible: providerHome!.ltsBanners.isNotEmpty,
                    child: Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      child: sliderBanner(providerHome?.indexBannerHeader, updateIndexBannerHeader, providerHome!.ltsBanners),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child:  sectionCategories(),
                  ),
                  const SizedBox(height: 55),
                  sectionsBrands(),
                  const SizedBox(height: 55),
                  //comment for update design
                /*  providerHome!.ltsBannersOffer.isEmpty ? Container() : sectionHighlight(),
                  const SizedBox(height: 55),
                  sectionBestSellers(),*/
                ],
              ),
            ):notConnectionInternet(),
          ),
        ),
      ],
    );
  }

  Widget sectionCategories() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              Strings.categories,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 24,
                  color: CustomColors.blueTitle,
                  fontFamily: Strings.fontBold
              ),
            ),
            /*     Comment for update design
       Expanded(
              child:GestureDetector(
                onTap: ()=> Navigator.push(context, customPageTransition(CategoriesPage())),
                child: Text(
                  Strings.seeAll,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 14,
                      color: CustomColors.blueTitle,
                      fontFamily: Strings.fontRegular
                  ),
                ),
              ) ,
            )*/
          ],
        ),
        SizedBox(height: 8,),
        AnimationLimiter(
          child: GridView.builder(
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 30,
              childAspectRatio: 0.9,
              crossAxisSpacing: 0,
            ),
            padding: EdgeInsets.only(top: 20),
            physics: NeverScrollableScrollPhysics(),
            itemCount: providerSettings.ltsCategories.length > 8
                ? 8
                : providerSettings.ltsCategories.length,
            shrinkWrap: true,
            itemBuilder: (_, int index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 375),
                columnCount: 4,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: InkWell(
                        onTap: () => openSubCategory(providerSettings.ltsCategories[index]),
                        child: itemCategory(providerSettings.ltsCategories[index])),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget sectionsBrands() {
    return providerHome!.ltsBrands.isEmpty?Container():Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Comment for update design
/*          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              Strings.enjoy,
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: Strings.fontRegular,
                  color: CustomColors.gray15),
            ),
          ),
          SizedBox(
            height: 6,
          ),*/
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
                        color: CustomColors.blueSplash),
                  ),
                ),
                const SizedBox(width: 5,),
                InkWell(
                  onTap: ()=>openAllBrands(),
                  child:  Text(
                    Strings.moreAll,
                    style: TextStyle(
                        color: CustomColors.blue,
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

  Widget sectionHighlight() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text(
              Strings.findHere,
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: Strings.fontRegular,
                  color: CustomColors.blueOne),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.highlightedOffers,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: Strings.fontBold,
                      color: CustomColors.blueSplash),
                ),
                InkWell(
                  onTap: () => Navigator.pushReplacement(context, customPageTransition( HighlightsPage())),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: CustomColors.blue.withOpacity(.1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                      child: Text(
                        Strings.moreAll,
                        style: TextStyle(
                            color: CustomColors.blueOne,
                            fontSize: 12,
                            fontFamily: Strings.fontBold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              height: 200,
              width: double.infinity,
              child: providerHome!.ltsBannersOffer.isEmpty
                  ? Center(child: loadingWidgets(70),)
                  : sliderBanner(providerHome!.indexBannerFooter,
                      updateIndexBannerFooter, providerHome!.ltsBannersOffer)),
          SizedBox(
            height: 10,
          ),
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
                color: CustomColors.gray15),
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
                    color: CustomColors.blueSplash),
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
      itemCount: providerHome!.ltsBrands.length > 6 ? 6 : providerHome!.ltsBrands.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (_, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 10 ),
          child: InkWell(
            onTap: ()=>openProductsByBrand(providerHome!.ltsBrands[index]),
              child: itemBrand(providerHome!.ltsBrands[index])),
        );
      },
    );
  }

  Widget listBestSellers() {
    return ListView.builder(
      itemCount: providerHome?.ltsMostSelledProducts.length??0,
      scrollDirection: Axis.horizontal,
      itemBuilder: (_, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: ()=>openDetailProduct(providerHome!.ltsMostSelledProducts[index]),
              child: itemProduct(providerHome!.ltsMostSelledProducts[index])),
        );
      },
    );
  }

  openProductsByBrand(Brand brand){
    Navigator.push(context, customPageTransition(ProductCategoryPage( idBrand:brand.id.toString())));
  }

  openAllBrands(){
    Navigator.push(context, customPageTransition(BrandsPage()));
  }

  openDetailProduct(Product product){
    String? color = product.references[0].color;
    if(product.references[0].images?.length != 0)
    {
      if (color != null  && color.startsWith('#') && color.length >= 6) {
        providerProducts?.imageReferenceProductSelected = product.references[0].images?[0].url ?? "";
        providerProducts?.limitedQuantityError = false;
        Navigator.push(context, customPageTransition(DetailProductPage(product: product)));
      }
    }
  }

  openSubCategory(Category category) {
    if(category.id == 0){
      Navigator.push(context, customPageTransition(CategoriesPage()));
    }else{
      Navigator.push(context,customPageTransition(SubCategoryPage(category: category,)));
    }
  }

  openPageSearch() {
    FocusScope.of(context).unfocus();
    if (searchController.text.isNotEmpty) {
      Navigator.push(
          context,
          customPageTransition(SearchProductHome(
            textSearch: searchController.text,
          )));
    }
  }

  updateIndexBannerFooter(int index) {
    providerHome!.indexBannerFooter = index;
  }

  updateIndexBannerHeader(int index) {
    providerHome!.indexBannerHeader = index;
  }

  void _pullToRefresh() async {
    await Future.delayed(Duration(milliseconds: 800));
    providerHome!.ltsBrands.clear();
    providerHome!.ltsBanners.clear();
    providerHome!.ltsBannersOffer.clear();
    providerSettings.ltsCategories.clear();
    providerHome!.ltsMostSelledProducts.clear();
    serviceGetCategories();
    getProductsMoreSelled();
    _refreshHome.refreshCompleted();
  }

  serviceGetCategories() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callSettings =
            providerSettings.getCategoriesInterest("", 0, prefs.countryIdUser);
        await callSettings.then((list) {
          getBrands();
          getProductsMoreSelled();
        }, onError: (error) {
          // utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

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
  }

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
  }

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
  }

  getProductsMoreSelled() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callHome = providerHome!.getProductsMostSelled();
        await callHome.then((list) {}, onError: (error) {

        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  selectCountryUserNotLogin() async {
    bool state = await openSelectCountry(context);
    if (state) serviceGetCategories();
  }

  void openWhatsapp(){
    utils.openWhatsapp(context: context, text: Strings.helloHelp, number: Constants.numberWhatsapp);
  }

  void openChatAdmin(){
    getRoomSupport(context);
  }

  getRoomSupport(BuildContext context) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callChat = providerChat.getRomAdmin();
        await callChat.then((id) async {
          if(socketService.serverStatus!=ServerStatus.Online){
            socketService.connectSocket(Constants.typeAdmin, id,"");
          }
          Navigator.push(context, customPageTransition(ChatPage(roomId: id, typeChat: Constants.typeAdmin,imageProfile: Constants.profileAdmin,fromPush: false)));
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}
