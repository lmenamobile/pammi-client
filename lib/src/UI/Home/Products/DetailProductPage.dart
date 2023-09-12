import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/Product/Product.dart';
import 'package:wawamko/src/Models/Product/Reference.dart';
import 'package:wawamko/src/Providers/ProviderCheckOut.dart';
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
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/ExpansionWidget.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class DetailProductPage extends StatefulWidget {
  final Product product;

  const DetailProductPage({required this.product});

  @override
  _DetailProductPageState createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  ProviderProducts? providerProducts;
  late ProviderShopCart providerShopCart;
  late ProviderSettings providerSettings;
  late ProviderCheckOut providerCheckOut;

  @override
  void initState() {
    providerProducts = Provider.of<ProviderProducts>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      providerProducts!.productDetail = widget.product;
      providerProducts!.referenceProductSelected = widget.product.references![0];
      providerProducts?.imageReferenceProductSelected = widget.product.references![0]?.images?[0].url ?? "";
      providerProducts!.unitsProduct = 1;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerProducts = Provider.of<ProviderProducts>(context);
    providerShopCart = Provider.of<ProviderShopCart>(context);
    providerSettings = Provider.of<ProviderSettings>(context);
    providerCheckOut = Provider.of<ProviderCheckOut>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              headerDoubleTap(context, widget.product.product!,"ic_car.png", CustomColors.redDot,providerShopCart.totalProductsCart, ()=> Navigator.pop(context), ()=>  Navigator.push(
              context, customPageTransition(ShopCartPage()))),
              /*titleBarWithDoubleAction(
                  ,
                  "ic_blue_arrow.png",
                  ",
                      () => Navigator.pop(context),
                      () =>
                     ,
                  true,
                  providerShopCart.totalProductsCart),*/
              Expanded(
                child: providerSettings.hasConnection ? SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 290,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15),)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            isImageYoutubeAction(providerProducts?.imageReferenceProductSelected ?? '',
                                InkWell(
                                  onTap: () => openZoomImages(),
                                  child: imageReference(
                                      170,
                                      providerProducts
                                          ?.imageReferenceProductSelected ??
                                          ''),
                                )),
                            Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 30),
                                height: 50,
                                child: listItemsImagesReferences()),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Strings.references,
                                style: TextStyle(
                                    color: CustomColors.blackLetter,
                                    fontFamily: Strings.fontMedium),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  String? color = providerProducts?.referenceProductSelected?.color;
                                  if(color != null  && color.startsWith('#') && color.length >= 6){
                                    openBottomSheetLtsReferences(context, setReference, providerProducts?.ltsReferencesProductSelected);
                                  }

                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: CustomColors.gray6,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 23, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              itemImageReference(
                                                  35, providerProducts!
                                                  .referenceProductSelected!
                                                  .images!.isEmpty ? '' :
                                              providerProducts
                                                  ?.referenceProductSelected
                                                  ?.images![0].url ?? ''),
                                              SizedBox(
                                                width: 13,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  providerProducts
                                                      ?.referenceProductSelected
                                                      ?.reference ??
                                                      '',
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontFamily:
                                                      Strings.fontRegular,
                                                      color: CustomColors
                                                          .gray7),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_right_outlined,
                                          color: CustomColors.gray7,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                providerProducts?.productDetail?.brandProvider
                                    ?.brand?.brand ??
                                    '',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: Strings.fontBold,
                                    color: CustomColors.gray7),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                providerProducts
                                    ?.referenceProductSelected?.reference ??
                                    '',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: Strings.fontBold,
                                    color: CustomColors.blueSplash),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              //PRODUCT COLOR
                              Row(
                                  children: [
                                    Visibility(
                                      visible: providerProducts?.referenceProductSelected?.color != "",
                                      child: Row(
                                       // mainAxisAlignment: MainAxisAlignment.,
                                        children: [
                                          Text(
                                              "Color ",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: Strings.fontRegular,
                                                color: CustomColors.blueSplash),
                                          ),
                                          Container(
                                            width: 30,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey.withOpacity(.2),width: 1),
                                              color:providerProducts?.referenceProductSelected?.color != "" ?
                                              Color(int.parse(providerProducts?.referenceProductSelected?.color?.toString().replaceAll('#', '0xFF') ?? "")) : Colors.yellow,
                                              borderRadius: BorderRadius.circular(10)
                                            ),
                                          )
                                        ],
                                      ),
                                    ),

                                   Visibility(
                                     visible: providerProducts?.referenceProductSelected?.size != "",
                                     child:   Expanded(
                                         child: Text(
                                            providerProducts?.referenceProductSelected?.color != "" ? " - Talla ${providerProducts?.referenceProductSelected?.size}" :  "Talla ${providerProducts?.referenceProductSelected?.size}",
                                           style: TextStyle(fontSize: 15, fontFamily: Strings.fontRegular, color: CustomColors.blueSplash),
                                         ),
                                   ),

                                   )

                                  ],

                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                  widget.product.service ?? false ? "${Strings.type}: ${Strings.service}" : "${Strings.type}: ${Strings.product}",
                                  style:TextStyle(
                                      fontSize: 15,
                                      fontFamily: Strings.fontBold,
                                      color: CustomColors.blackLetter)
                              ),
                              rowStars(double.parse(providerProducts
                                  ?.referenceProductSelected
                                  ?.qualification ??
                                  '0')),
                              Visibility(
                                visible: providerProducts
                                    ?.referenceProductSelected
                                    ?.totalProductOffer?.status ?? false,
                                child: Text(
                                  formatMoney(
                                      providerProducts?.referenceProductSelected
                                          ?.price ?? '0'),
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 18,
                                      fontFamily: Strings.fontMedium,
                                      color: CustomColors.gray4),
                                ),
                              ),
                              Text(
                                formatMoney(
                                    providerProducts?.referenceProductSelected
                                        ?.totalProductOffer?.status == true ?
                                    providerProducts?.referenceProductSelected
                                        ?.totalProductOffer?.priceWithDiscount :
                                    providerProducts?.referenceProductSelected
                                        ?.price ??
                                        '0'),
                                style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: Strings.fontMedium,
                                    color: CustomColors.orange),
                              ),
                              rowButtonsMoreAndLess(
                                  providerProducts!.unitsProduct.toString(),
                                  addProduct,
                                  removeProduct),
                              customDivider(),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    btnCustom(
                                        120,
                                        Strings.paymentNow,
                                        CustomColors.orange,
                                        Colors.white,
                                            () => paymentNow()),
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
                                            Colors.white,
                                                () => addProductCart()),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      sectionDescriptionProduct()
                    ],
                  ),
                ) : notConnectionInternet(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionDescriptionProduct() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            ExpansionWidget(
              initiallyExpanded: true,
              iconColor: CustomColors.gray7,
              title: Row(
                children: [
                  Icon(
                    Icons.info_rounded,
                    color: CustomColors.blue,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    Strings.productInformation,
                    style: TextStyle(
                        fontFamily: Strings.fontRegular,
                        color: CustomColors.blue),
                  ),
                ],
              ),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customDivider(),
                    Text(
                      Strings.description,
                      style: TextStyle(
                          fontFamily: Strings.fontBold,
                          color: CustomColors.black1),
                    ),
                    Html(
                      data: providerProducts?.productDetail?.characteristics,
                    ),
                    customDivider(),
                    Text(
                      Strings.conditions,
                      style: TextStyle(
                          fontFamily: Strings.fontBold,
                          color: CustomColors.black1),
                    ),
                    Html(
                      data: providerProducts?.productDetail?.conditions,
                    ),
                  ],
                )
              ],
            ),
            customDivider(),
            ExpansionWidget(
              initiallyExpanded: true,
              iconColor: CustomColors.gray7,
              title: Row(
                children: [
                  Icon(
                    Icons.comment,
                    color: CustomColors.blue,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    Strings.comments,
                    style: TextStyle(
                        fontFamily: Strings.fontRegular,
                        color: CustomColors.blackLetter),
                  ),
                ],
              ),
              children: [
                Container(

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customDivider(),
                      listComments()],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget listItemsImagesReferences() {
    return ListView.builder(
      itemCount: providerProducts?.referenceProductSelected?.images == null
          ? 0
          : providerProducts?.referenceProductSelected?.images?.length,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(right: 5),
          child: InkWell(
              onTap: () =>
                  setImageReference(providerProducts
                      ?.referenceProductSelected?.images![index].url),
              child: itemImageReference(50, providerProducts?.referenceProductSelected?.images?[index].url ?? '')),
        );
      },
    );
  }

  Widget listComments() {
    return ListView.builder(
      itemCount: providerProducts?.referenceProductSelected?.ltsComments == null
          ? 0
          : providerProducts?.referenceProductSelected?.ltsComments?.length,
      shrinkWrap: true,
      itemBuilder: (_, int index) {
        return Padding(
          padding: const EdgeInsets.only(right: 5, bottom: 5),
          child: itemComment(
              providerProducts!.referenceProductSelected!.ltsComments![index]),
        );
      },
    );
  }

  setImageReference(String? asset) {
    providerProducts?.imageReferenceProductSelected = asset;
  }

  setReference(Reference reference) {
    providerProducts?.referenceProductSelected = reference;
    providerProducts?.productDetail?.references?.forEach((element) {
      if (element != reference) {
        element.isSelected = false;
      }
    });
    Navigator.pop(context);
  }

  openZoomImages() {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            PhotosProductPage(
              image: providerProducts?.imageReferenceProductSelected,
            )));
  }

  addProductCart() async {
    if (providerProducts!.prefs.authToken != "0") {
      utils.checkInternet().then((value) async {
        if (value) {
          Future callCart = providerShopCart.updateQuantityProductCart(
              providerProducts!.referenceProductSelected!.id!.toString(),
              providerProducts!.unitsProduct.toString());
          await callCart.then((msg) async{
            Navigator.pop(context);
            utils.showSnackBarGood(context, msg.toString());
            await providerShopCart.getShopCart(providerCheckOut.paymentSelected?.id ?? 2);
          }, onError: (error) {
            utils.showSnackBar(context, error.toString());
          });
        } else {
          utils.showSnackBarError(context, Strings.loseInternet);
        }
      });
    }else{
      validateSession(context);
    }
  }

  paymentNow() async {
    if (providerProducts!.prefs.authToken != "0") {
      utils.checkInternet().then((value) async {
        if (value) {
          Future callCart = providerShopCart.updateQuantityProductCart(
              providerProducts!.referenceProductSelected!.id.toString(),
              providerProducts!.unitsProduct.toString());
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
    }else{
      validateSession(context);
    }
  }

  getShopCart() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerShopCart.getShopCart(providerCheckOut.paymentSelected?.id ?? 2);
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

  addProduct() {
    if (providerProducts!.prefs.authToken != "0") {
      providerProducts!.unitsProduct = providerProducts!.unitsProduct + 1;
    } else {
      validateSession(context);
    }
  }

  removeProduct() {
    if (providerProducts!.prefs.authToken != "0") {
      if (providerProducts!.unitsProduct > 1)
        providerProducts!.unitsProduct = providerProducts!.unitsProduct - 1;
    } else {
      validateSession(context);
    }
  }
}
