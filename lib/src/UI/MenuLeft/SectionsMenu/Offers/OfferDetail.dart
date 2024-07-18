import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/Offer.dart';
import 'package:wawamko/src/Models/Product/Reference.dart';
import 'package:wawamko/src/Providers/ProviderCheckOut.dart';
import 'package:wawamko/src/Providers/ProviderOffer.dart';
import 'package:wawamko/src/Providers/ProviderProducts.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Providers/ProviderShopCart.dart';
import 'package:wawamko/src/UI/Home/Categories/Widgets.dart';
import 'package:wawamko/src/UI/Home/Products/PhotosProductPage.dart';
import 'package:wawamko/src/UI/Home/Products/Widgets.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/ShopCart/CheckOut/CheckOutPage.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/ShopCart/ShopCartPage.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/config/theme/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class OfferDetail extends StatefulWidget {
  final String? nameOffer, idOffer;

  const OfferDetail({required this.nameOffer, required this.idOffer});

  @override
  _OfferDetailState createState() => _OfferDetailState();
}

class _OfferDetailState extends State<OfferDetail> {
  ProviderOffer? providerOffer;
  late ProviderShopCart providerShopCart;
  late ProviderSettings providerSettings;
  late ProviderProducts providerProducts;
  late ProviderCheckOut providerCheckOut;


  @override
  void initState() {
    providerOffer = Provider.of<ProviderOffer>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      providerOffer!.totalUnits = 1;
      getDetailOffer(widget.idOffer);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerOffer = Provider.of<ProviderOffer>(context);
    providerSettings = Provider.of<ProviderSettings>(context);
    providerShopCart = Provider.of<ProviderShopCart>(context);
    providerProducts = Provider.of<ProviderProducts>(context);
    providerCheckOut = Provider.of<ProviderCheckOut>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color:  Colors.white,
          child: Column(
            children: [
             
              headerDoubleTapMenu(context, widget.nameOffer ?? '', "ic_car.png", "", AppColors.redDot, providerShopCart.totalProductsCart, () => Navigator.pop(context), (){Navigator.push(context,
                  customPageTransition(ShopCartPage(),PageTransitionType.fade));providerProducts.limitedQuantityError = false;}),
              Expanded(
                child: providerSettings.hasConnection
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            sliderProductOffer(),
                             Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              rowButtonsMoreAndLess(providerOffer!.totalUnits.toString(), addProduct, removeProduct),
                              Visibility(
                                visible:providerProducts.limitedQuantityError == true ? false :true,
                                //provider.products?[0].offer?.promotionProducts?[0].reference?.qty
                                child: Text("${Strings.quantityAvailable} ${providerOffer!.detailOffer.promotionProducts?[0].reference?.qty}",
                                  style: TextStyle(fontSize: 14, fontFamily: Strings.fontRegular, color: AppColors.gray),
                                ),
                              ),
                              Visibility(
                                visible:providerProducts.limitedQuantityError == true ? true :false,
                                child: Container(
                                  decoration: BoxDecoration(color: Colors.yellow, borderRadius: BorderRadius.circular(15),),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${Strings.youCanOnlyCarry} ${providerOffer!.detailOffer.promotionProducts?[0].reference?.qty} unidades",
                                      style: TextStyle(fontSize: 14, fontFamily: Strings.fontRegular, color: AppColors.blueDarkSplash,),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          )
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                Strings.productsPerPurchase,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: Strings.fontBold,
                                    color: AppColors.gray7),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 217,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: listProductsGiftOffer(),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                                child: Divider()),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                              child: Row(
                                children: [
                                  btnCustom(
                                      120,
                                      Strings.paymentNow,
                                      AppColors.orange,
                                      Colors.white,() => paymentNow()),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: 200,
                                      child: btnCustomIconLeft(
                                          "ic_pay_add.png",
                                          Strings.addCartShop,
                                          AppColors.blue,
                                          Colors.white, (){addOfferCart(providerOffer!.detailOffer.id.toString());}),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                          ],
                        ),
                      )
                    : notConnectionInternet(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget itemSliderOffer(Reference? reference) {
    return Container(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => openZoomImages(),
                  child:
                      imageReference(Size(170,170), providerOffer?.imageSelected ?? ''),
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    height: 50,
                    child: listItemsImagesReferences()),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    providerOffer?.detailOffer.name ?? '',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: Strings.fontBold,
                        color: AppColors.blackLetter),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    reference?.reference ?? '',
                    style: TextStyle(
                        fontSize: 19,
                        fontFamily: Strings.fontMedium,
                        color: AppColors.blackLetter),
                  ),
                  Text(
                    formatMoney(reference?.price ?? '0'),
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: Strings.fontMedium,
                        color: AppColors.orange),
                  ),
                ]),
          ),
        ],
      ),
    );
  }

  Widget sliderProductOffer() {
    return Container(
      child: CarouselSlider.builder(
          itemCount: providerOffer?.detailOffer.baseProducts == null
              ? 0
              : providerOffer!.detailOffer.baseProducts!.length,
          itemBuilder: (_, int itemIndex, int pageViewIndex) => itemSliderOffer(
              providerOffer?.detailOffer.baseProducts![itemIndex].reference),
          options: CarouselOptions(
            height: 360,
            enableInfiniteScroll: false,
            autoPlay: false,
          )),
    );
  }

  Widget itemProductOffer(Reference reference, String? brand,Offer offer) {
    int position = getRandomPosition(reference.images?.length ?? 0);
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  child: FadeInImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(reference.images?[position].url ?? ''),
                    placeholder: AssetImage("Assets/images/spinner.gif"),
                    imageErrorBuilder: (_,__,___){
                      return Container();
                    },
                  ),
                ),
                customDivider(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        brand ?? '',
                        style: TextStyle(
                          fontFamily: Strings.fontRegular,
                          fontSize: 12,
                          color: AppColors.gray7,
                        ),
                      ),
                      Text(
                        reference.reference ?? '',
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: Strings.fontRegular,
                          fontSize: 13,
                          color: AppColors.blackLetter,
                        ),
                      ),
                      Text(
                        formatMoney(reference.price??'0'),
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 13,
                            fontFamily: Strings.fontMedium,
                            color: AppColors.gray
                        ),
                      ),
                      Text(
                        offer.offerType=="units"?formatMoney('0'):formatMoney(priceDiscount(reference.price??'0', offer.discountValue!)),
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: Strings.fontMedium,
                            color: AppColors.orange
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget listItemsImagesReferences() {
    return ListView.builder(
      itemCount:
          providerOffer?.detailOffer.baseProducts?[0].reference?.images == null
              ? 0
              : providerOffer!
                  .detailOffer.baseProducts![0].reference!.images!.length,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(right: 5),
          child: InkWell(
              onTap: () => setImageReference(providerOffer?.detailOffer
                      .baseProducts?[0].reference?.images?[index].url ??
                  ''),
              child: itemImageReference(
                  Size(50, 50),
                  providerOffer?.detailOffer.baseProducts?[0].reference
                          ?.images?[index].url ??
                      '',"")),
        );
      },
    );
  }

  Widget listProductsGiftOffer() {
    return ListView.builder(
      itemCount: providerOffer?.detailOffer.promotionProducts == null
          ? 0
          : providerOffer?.detailOffer.promotionProducts?.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: itemProductOffer(
                providerOffer!.detailOffer.promotionProducts![index].reference!,
                providerOffer?.detailOffer.brandProvider?.brand?.brand,providerOffer!.detailOffer));
      },
    );
  }

  setImageReference(String? asset) {
    providerOffer?.imageSelected = asset;
  }

  openZoomImages() {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => PhotosProductPage(
              image: providerOffer?.imageSelected,
            )));
  }


  addProduct() {
      if (providerOffer!.totalUnits < int.parse(providerOffer!.detailOffer.promotionProducts?[0].reference?.qty.toString() ?? "")) {
        providerOffer!.totalUnits = providerOffer!.totalUnits + 1;
      } else {
        providerProducts.limitedQuantityError = true;
      }
  }


  removeProduct() {
      if (providerOffer!.totalUnits > 1) {
        providerProducts.limitedQuantityError = false;
        providerOffer?.totalUnits = providerOffer!.totalUnits - 1;
      } else {
        providerOffer?.totalUnits = 1;
      }

  }

  getDetailOffer(String? idOffer) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callOffer = providerOffer!.getDetailOffer(idOffer);
        await callOffer.then((offer) {}, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  addOfferCart(String idOffer) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerShopCart.addOfferCart(idOffer, providerOffer?.totalUnits.toString() ?? '',providerCheckOut.paymentSelected?.id ?? 2);
        await callCart.then((msg) {
          providerProducts.limitedQuantityError = false;
          utils.showSnackBarGood(context, msg.toString());
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  paymentNow() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerShopCart.addOfferCart(
            providerOffer!.detailOffer.id.toString(),
            providerOffer?.totalUnits.toString() ?? '',providerCheckOut.paymentSelected?.id ?? 2);
        await callCart.then((msg) {
          getShopCart();
          utils.showSnackBarGood(context, msg.toString());
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  getShopCart() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerShopCart.getShopCart(providerCheckOut.paymentSelected?.id ?? 2);
        await callCart.then((msg) {
          Navigator.push(context, customPageTransition(CheckOutPage(), PageTransitionType.fade));
        }, onError: (error) {
          providerShopCart.isLoadingCart = false;
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }


}
