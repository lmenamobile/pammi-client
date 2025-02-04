import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
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
import 'package:wawamko/src/config/theme/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/ExpansionWidget.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/features/feature_products/presentation/presentation.dart';
import 'package:wawamko/src/features/feature_products/presentation/views/products_page.dart';

import '../../../features/feature_products/domain/domain.dart';

class DetailProductPage extends StatefulWidget {
  final Product? product;

  const DetailProductPage({required this.product});

  @override
  _DetailProductPageState createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  late  ProductsProvider providerProducts;
  late ProviderShopCart providerShopCart;
  late ProviderSettings providerSettings;
  late ProviderCheckOut providerCheckOut;

  @override
  void initState() {
    providerProducts = Provider.of<ProductsProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerProducts = Provider.of(context);
    providerShopCart = Provider.of<ProviderShopCart>(context);
    providerSettings = Provider.of<ProviderSettings>(context);
    providerCheckOut = Provider.of<ProviderCheckOut>(context);

    final product = widget.product;

    return Scaffold(
      backgroundColor: AppColors.whiteBackGround,
      body: SafeArea(
        child: Container(
            color: AppColors.whiteBackGround,
          child: Column(
            children: [
              headerWithActions(Strings.productDetail,()=>Navigator.pop(context), openShopCart),
              Expanded(
                child: providerSettings.hasConnection ? SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //IMAGE PRODUCT
                      Container(
                        width: double.infinity,
                        height: 428,
                        child: isImageYoutubeAction(product?.getPrincipalReference?.mediaResourcesReference.first.url?? '',
                            InkWell(
                              onTap: () => openZoomImages(),
                              child: imageReference(Size(double.infinity, 428), product?.getPrincipalReference?.mediaResourcesReference.first.url?? ''),
                            )),
                      ),

                      //LIST IMAGES REFERENCES
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        height: 90,
                        child: listItemsImagesReferences(product?.getPrincipalReference?.mediaResourcesReference),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product?.brandProvider.brand.brand ?? '',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: Strings.fontBold,
                                    color: AppColors.gray7),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                product?.getPrincipalReference?.referenceName ?? '',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: Strings.fontBold,
                                    color: AppColors.blueSplash),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                  widget.product?.service ?? false ? "${Strings.type}: ${Strings.service}" : "${Strings.type}: ${Strings.product}",
                                  style:TextStyle(
                                      fontSize: 15,
                                      fontFamily: Strings.fontBold,
                                      color: AppColors.blackLetter)
                              ),
                              rowStars(product?.getPrincipalReference?.rating?? 0),
                              Visibility(
                                visible: providerProducts
                                    ?.referenceProductSelected
                                    ?.totalProductOffer?.status ?? false,
                                child: Text(
                                  formatMoney(providerProducts?.referenceProductSelected?.price ?? '0'),
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 18,
                                      fontFamily: Strings.fontMedium,
                                      color: AppColors.gray4),
                                ),
                              ),
                              Text(
                                formatMoney(
                                    providerProducts?.referenceProductSelected?.totalProductOffer?.status == true ?
                                    providerProducts?.referenceProductSelected?.totalProductOffer?.priceWithDiscount :
                                    providerProducts?.referenceProductSelected?.price ?? '0'),
                                style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: Strings.fontMedium,
                                    color: AppColors.orange),
                              ),
                              SizedBox(height: 10,),
                              //SECTIONS BUTTONS AN CONDITIONS DELIVERY
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        Strings.quantity,
                                        style: TextStyle(
                                          fontSize: 16,
                                            fontFamily: Strings.fontMedium,
                                            color: AppColors.black),
                                      ),
                                      rowButtonsMoreAndLess(providerProducts!.unitsProduct.toString(), addProduct, removeProduct),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Visibility(
                                    visible:providerProducts?.limitedQuantityError == true ? false :true,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              "Assets/images/truck.svg",
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              Strings.deliveryDomicile,
                                              style: TextStyle(
                                                  fontFamily: Strings.fontRegular,
                                                  color: AppColors.gray),
                                            )
                                          ],
                                        ),
                                        Text("${Strings.quantityAvailable} ${providerProducts?.referenceProductSelected?.qty}",
                                          style: TextStyle( fontFamily: Strings.fontRegular, color: AppColors.gray),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible:providerProducts?.limitedQuantityError == true ? true :false,
                                    child: Container(
                                      decoration: BoxDecoration(color: Colors.yellow, borderRadius: BorderRadius.circular(15),),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "${Strings.youCanOnlyCarry} ${providerProducts?.referenceProductSelected?.qty} unidades",
                                          style: TextStyle(fontSize: 14, fontFamily: Strings.fontRegular, color: AppColors.blueDarkSplash,),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              customDivider(),

                              //BUTTONS PAYMENT AND ADD CART
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  children: [
                                    btnCustomContent(
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset("Assets/images/ic_shoppingcart.svg",),
                                        SizedBox(width: 10,),
                                        Text(
                                          Strings.addCartShop.toUpperCase(),
                                          style: TextStyle(
                                              fontFamily: Strings.fontRegular, color: Colors.white),
                                        )
                                      ],
                                    ), AppColors.blueSplash,AppColors.blueSplash, () => addProductCart()),
                                    const SizedBox(height: 16,),
                                    btnCustomContent(
                                        Text(
                                          Strings.paymentNow.toUpperCase(),
                                          style: TextStyle(
                                              fontFamily: Strings.fontRegular,
                                              color: Colors.white),
                                        ), AppColors.redDot,
                                        AppColors.redDot,  () => paymentNow()),
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

/*  Widget sectionDescriptionProduct() {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.whiteBackGround,
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
              iconColor: AppColors.gray7,
              title: Row(
                children: [
                  Icon(
                    Icons.info_rounded,
                    color: AppColors.blue,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    Strings.productInformation,
                    style: TextStyle(
                        fontFamily: Strings.fontRegular,
                        color: AppColors.blue),
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
                          color: AppColors.black1),
                    ),
                    Html(
                      data: providerProducts?.productDetail?.characteristics,
                    ),
                    customDivider(),
                    Text(
                      Strings.conditions,
                      style: TextStyle(
                          fontFamily: Strings.fontBold,
                          color: AppColors.black1),
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
              iconColor: AppColors.gray7,
              title: Row(
                children: [
                  Icon(
                    Icons.comment,
                    color: AppColors.blue,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    Strings.comments,
                    style: TextStyle(
                        fontFamily: Strings.fontRegular,
                        color: AppColors.blackLetter),
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

  Widget listItemsImagesReferences(List<ImageProduct>? images) {
    return ListView.builder(
      itemCount: images == null ? 0 : images.length,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      padding: EdgeInsets.only(left: 20),
      itemBuilder: (_, int index) {
        return Padding(
          padding: const EdgeInsets.only(right: 15),
          child: InkWell(
              onTap: () => setImageReference(images![index].url),
              child: itemImageReference(Size(80, 80), images?[index].url ?? '',providerProducts?.imageReferenceProductSelected ?? '')),
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
    providerProducts!.unitsProduct = 1;
    providerProducts?.limitedQuantityError = false;
    providerProducts?.referenceProductSelected = reference;
    providerProducts?.productDetail?.references.forEach((element) {
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
            //Navigator.pop(context);
            Navigator.push(
                context, customPageTransition(ShopCartPage(),PageTransitionType.rightToLeftWithFade));
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
          Navigator.push(context, customPageTransition(CheckOutPage(), PageTransitionType.rightToLeftWithFade));
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
      if (providerProducts!.unitsProduct < int.parse(providerProducts!.referenceProductSelected!.qty.toString())) {
        providerProducts!.unitsProduct = providerProducts!.unitsProduct + 1;
      } else {
        providerProducts?.limitedQuantityError = true;
      }

    } else {
      validateSession(context);
    }
  }

  removeProduct() {
    if (providerProducts!.prefs.authToken != "0") {
      if (providerProducts!.unitsProduct > 1) {
        providerProducts?.limitedQuantityError = false;
        providerProducts!.unitsProduct = providerProducts!.unitsProduct - 1;
      } else {
        providerProducts!.unitsProduct = 1;
      }
    } else {
      validateSession(context);
    }
  }

  void openShopCart() {
    Navigator.push(context, customPageTransition(ShopCartPage(),PageTransitionType.rightToLeftWithFade));
  }*/

}
