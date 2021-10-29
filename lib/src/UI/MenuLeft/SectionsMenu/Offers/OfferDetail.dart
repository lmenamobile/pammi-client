import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/Product/Reference.dart';
import 'package:wawamko/src/Providers/ProviderOffer.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Providers/ProviderShopCart.dart';
import 'package:wawamko/src/UI/Home/Categories/Widgets.dart';
import 'package:wawamko/src/UI/Home/Products/PhotosProductPage.dart';
import 'package:wawamko/src/UI/Home/Products/Widgets.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/ShopCart/CheckOut/CheckOutPage.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

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

  @override
  void initState() {
    providerOffer = Provider.of<ProviderOffer>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
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
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      body: SafeArea(
        child: Container(
          color: CustomColors.whiteBackGround,
          child: Column(
            children: [
              titleBarWithDoubleAction(widget.nameOffer ?? '',
                  "ic_blue_arrow.png", "", () => Navigator.pop(context), () {},false,""),
              Expanded(
                child: providerSettings.hasConnection?SingleChildScrollView(
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
                              rowButtonsMoreAndLess(
                                  providerOffer!.totalUnits.toString(),
                                  addProduct,
                                  removeProduct),
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
                                    color: CustomColors.gray7),
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
                                      CustomColors.orange,
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
                                          CustomColors.blue,
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
                ):notConnectionInternet(),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                )),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => openZoomImages(),
                  child: imageReference(170, providerOffer?.imageSelected ?? ''),
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    height: 50,
                    child: listItemsImagesReferences()),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      providerOffer?.detailOffer.name ?? '',
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: Strings.fontBold,
                          color: CustomColors.blackLetter),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      Strings.productsPerPurchase,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: Strings.fontBold,
                          color: CustomColors.gray7),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      reference?.reference ?? '',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: Strings.fontBold,
                          color: CustomColors.blackLetter),
                    ),
                    Text(
                      formatMoney(reference?.price ?? '0'),
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: Strings.fontMedium,
                          color: CustomColors.orange),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget sliderProductOffer() {
    return Container(
      height: 390,
      child:
      CarouselSlider.builder(
        itemCount: providerOffer?.detailOffer.baseProducts == null ? 0 : providerOffer!.detailOffer.baseProducts!.length,
        itemBuilder: (_, int itemIndex, int pageViewIndex) => itemSliderOffer(providerOffer?.detailOffer.baseProducts![itemIndex].reference),
          options: CarouselOptions(
              autoPlay: false,
          )
      ),
    );
  }

  Widget itemProductOffer(Reference reference, String? brand) {
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
                    image: NetworkImage(reference.images?[position].url??''),
                    placeholder: AssetImage("Assets/images/spinner.gif"),
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
                          color: CustomColors.gray7,
                        ),
                      ),
                      Text(
                        reference.reference ?? '',
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: Strings.fontRegular,
                          fontSize: 13,
                          color: CustomColors.blackLetter,
                        ),
                      ),
                      Text(
                        formatMoney(reference.price ?? '0'),
                        style: TextStyle(
                          fontFamily: Strings.fontBold,
                          color: CustomColors.orange,
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
              : providerOffer!.detailOffer.baseProducts![0].reference!.images!.length,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(right: 5),
          child: InkWell(
              onTap: () => setImageReference(providerOffer?.detailOffer.baseProducts?[0].reference?.images?[index].url??''),
              child: itemImageReference(50, providerOffer?.detailOffer.baseProducts?[0].reference?.images?[index].url??'')),
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
                providerOffer?.detailOffer.brandProvider?.brand?.brand));
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
    providerOffer?.totalUnits = providerOffer!.totalUnits + 1;
  }

  removeProduct() {
    if (providerOffer!.totalUnits > 1)
      providerOffer?.totalUnits = providerOffer!.totalUnits - 1;
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
        Future callCart = providerShopCart.addOfferCart(idOffer, providerOffer?.totalUnits.toString()??'');
        await callCart.then((msg) {
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
        Future callCart = providerShopCart.addOfferCart(providerOffer!.detailOffer.id.toString(), providerOffer?.totalUnits.toString()??'');
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
        Future callCart = providerShopCart.getShopCart();
        await callCart.then((msg) {
          Navigator.push(context, customPageTransition(CheckOutPage()));
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
