import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/ProfileProvider.dart';
import 'package:wawamko/src/Providers/ProviderProducts.dart';
import 'package:wawamko/src/Providers/ProviderShopCart.dart';
import 'package:wawamko/src/UI/Home/Categories/Widgets.dart';
import 'package:wawamko/src/UI/Home/Products/Widgets.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/ShopCart/ProductsSavePage.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

import 'Widgets.dart';

class ShopCartPage  extends StatefulWidget {
  @override
  _ShopCartPageState createState() => _ShopCartPageState();
}

class _ShopCartPageState extends State<ShopCartPage> {

  ProviderShopCart providerShopCart;
  ProviderProducts providerProducts;
  int pageOffsetProductsRelations = 0;

  @override
  void initState() {
    providerShopCart = Provider.of<ProviderShopCart>(context,listen: false);
    providerProducts = Provider.of<ProviderProducts>(context,listen: false);
    providerProducts.ltsProductsRelationsByReference.clear();
    getShopCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerShopCart = Provider.of<ProviderShopCart>(context);
    providerProducts = Provider.of<ProviderProducts>(context);
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      body: SafeArea(
        child: Container(
          color: CustomColors.whiteBackGround,
          child: Stack(
            children: [
              titleBarWithDoubleAction(
                  Strings.shopCart,
                  "ic_blue_arrow.png",
                  "ic_car.png",
                      () => Navigator.pop(context),
                  null),
              Column(
                children: [
                  SizedBox(height: 55,),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: CustomColors.whiteBackGround,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        )
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            listProductsByProvider(),
                            itemSubtotalCart(providerShopCart?.shopCart?.totalCart,()=>Navigator.push(context, customPageTransition(ProductsSavePage()))),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                                  child: Text(
                                    Strings.productsRelations,
                                    style:TextStyle(
                                        fontFamily: Strings.fontBold,
                                        color: CustomColors.blackLetter
                                    ) ,
                                  ),
                                ),
                                Container(
                                    height: 210,
                                    child: listItemsProductsRelations()),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget listProductsByProvider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: providerShopCart?.shopCart?.packagesProvider==null?0:providerShopCart?.shopCart?.packagesProvider?.length,
        itemBuilder: (BuildContext context, int index) {
          return cardListProductsByProvider(providerShopCart?.shopCart?.packagesProvider[index],updateProductCart,deleteProduct,saveProduct);
        },
      ),
    );
  }

  Widget listItemsProductsRelations() {
    return ListView.builder(
      itemCount: providerProducts.ltsProductsRelationsByReference.isEmpty?0:providerProducts.ltsProductsRelationsByReference.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: itemProductCategory(providerProducts.ltsProductsRelationsByReference[index],openDetailProduct,null)
        );
      },
    );
  }

  openDetailProduct() {

  }

  getShopCart() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerShopCart.getShopCart();
        await callCart.then((msg) {
          getProductsRelations();
        }, onError: (error) {
          providerShopCart.isLoadingCart = false;
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

  updateProductCart(int quantity,String idReference) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerShopCart.updateQuantityProductCart(
            idReference,
            quantity.toString());
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

  deleteProduct(String idProduct) async {
    bool status = await showDialogDoubleAction(context,Strings.delete,Strings.deleteProduct,"ic_trash_big.png");
    if(status)
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerShopCart.deleteProductCart(idProduct);
        await callCart.then((msg) {
          getShopCart();
          utils.showSnackBarGood(context, msg.toString());
        }, onError: (error) {
          providerShopCart.isLoadingCart = false;
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

  saveProduct(String idReference,String quantity,String idProduct) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerShopCart.saveReference(idReference, quantity);
        await callCart.then((msg) {
         deleteProduct(idProduct);
          utils.showSnackBarGood(context, msg.toString());
        }, onError: (error) {
          providerShopCart.isLoadingCart = false;
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

  getProductsRelations() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callProducts = providerProducts.getProductsRelationByReference(pageOffsetProductsRelations, providerShopCart?.shopCart?.packagesProvider[0].products[0].reference?.id.toString());
        await callProducts.then((list) {

        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}