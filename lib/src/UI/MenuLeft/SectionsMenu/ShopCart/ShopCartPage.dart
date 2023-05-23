import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Animations/animate_button.dart';
import 'package:wawamko/src/Models/Address/GetAddress.dart';
import 'package:wawamko/src/Models/Product/Product.dart';
import 'package:wawamko/src/Models/Product/Reference.dart';
import 'package:wawamko/src/Providers/ProviderCheckOut.dart';
import 'package:wawamko/src/Providers/ProviderProducts.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Providers/ProviderShopCart.dart';
import 'package:wawamko/src/Providers/ProviderUser.dart';
import 'package:wawamko/src/Providers/UserProvider.dart';
import 'package:wawamko/src/UI/Home/Categories/Widgets.dart';
import 'package:wawamko/src/UI/Home/Products/DetailProductPage.dart';
import 'package:wawamko/src/UI/Home/Products/Widgets.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/ShopCart/ProductsSavePage.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

import 'CheckOut/CheckOutPage.dart';
import 'Widgets.dart';

class ShopCartPage extends StatefulWidget {
  @override
  _ShopCartPageState createState() => _ShopCartPageState();
}

class _ShopCartPageState extends State<ShopCartPage> {
  late ProviderShopCart providerShopCart;
  late ProviderProducts providerProducts;
  late ProviderUser providerUser;
  late ProviderSettings providerSettings;
  late ProviderCheckOut providerCheckOut;
  int pageOffsetProductsRelations = 0;

  @override
  void initState() {
    providerShopCart = Provider.of<ProviderShopCart>(context, listen: false);
    providerProducts = Provider.of<ProviderProducts>(context, listen: false);

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      providerProducts.ltsProductsRelationsByReference.clear();
      providerShopCart.shopCart = null;
      providerShopCart.totalProductsCart = "0";
      providerShopCart.getLtsReferencesSave(0);
      getShopCart();

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
    providerShopCart = Provider.of<ProviderShopCart>(context);
    providerProducts = Provider.of<ProviderProducts>(context);
    providerUser = Provider.of<ProviderUser>(context);
    providerCheckOut = Provider.of<ProviderCheckOut>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              headerDoubleTap(context, Strings.shopCart, "ic_remove_white.png", CustomColors.redDot, "0", ()=>Navigator.pop(context), ()=>deleteCart()),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child:_showBody()
                ),
              ),
              Visibility(
                visible: providerSettings.hasConnection
                    ? providerShopCart.shopCart != null || (providerShopCart.shopCart?.packagesProvider?.isNotEmpty??false) && (providerShopCart.shopCart?.products?.isNotEmpty??false)
                    : false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimateButton(
                    pressEvent: (){
                      Navigator.pop(context);
                    },
                    color: CustomColors.blue,
                    width: double.infinity,
                    body: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('Assets/images/ic_cartback.svg'),
                        Text(
                          Strings.continueShopping,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: Strings.fontMedium,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  )
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }


  Widget _showBody(){
    if( providerSettings.hasConnection && providerShopCart.shopCart == null && !providerShopCart.isLoadingCart && !providerProducts.isLoadingProducts && !providerShopCart.loading){
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            emptyData(
                "ic_highlights_empty.png",
                Strings.sorryHighlights,
                Strings.emptyProductsSave),
            SizedBox(height: 10,),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: InkWell(
                    onTap: ()=>openProductsSave(),
                    child: Container(
                      decoration: BoxDecoration(
                          color: CustomColors.orange,
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                        child: Image.asset("Assets/images/ic_box.png",height: 40,),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.redAccent,
                  ),
                )
              ],
            )
          ],
        ),
      );
    }else if(!providerSettings.hasConnection){
      return notConnectionInternet();
    }else if(providerShopCart.isLoadingCart || providerShopCart.loading){
      return LoadingProgress();
    }else if(providerShopCart.shopCart != null && !providerShopCart.isLoadingCart){
      return SingleChildScrollView(
        child: Column(
          children: [
            providerShopCart.shopCart!
                .packagesProvider!.isEmpty
                ? sectionGiftCard()
                : listProductsByProvider(),
            itemSubtotalCart(
              providerShopCart.shopCart?.totalCart,
                  () =>  openProductsSave(),
                  () => Navigator.push(
                  context,
                  customPageTransition(
                      CheckOutPage())).then((value) {
                //getShopCart();
                //getShippingPrice();
              }),
            ),
            Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 15, vertical: 10),
                  child: Text(
                    Strings.productsRelations,
                    style: TextStyle(
                        fontFamily: Strings.fontBold,
                        color:
                        CustomColors.blackLetter),
                  ),
                ),
                Container(
                    height: 217,
                    child:
                    listItemsProductsRelations()),
              ],
            )
          ],
        ),
      );
    }else {
        return Container();
    }
  }


  Widget listProductsByProvider() {

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: providerShopCart.shopCart?.packagesProvider == null
            ? 0
            : providerShopCart.shopCart?.packagesProvider?.length,
        itemBuilder: (BuildContext context, int index) {
          return cardListProductsByProvider(
              providerShopCart.shopCart!.packagesProvider![index],
              updateOfferOrProduct,
              callDeleteProduct,
              providerShopCart.hasPrincipalAddress,
              saveProduct);
        },
      ),
    );
  }

  Widget sectionGiftCard() {
    return providerShopCart.shopCart?.products == null
        ? Container()
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: listGiftCard(providerShopCart.shopCart?.products,
                updateGiftCard, callDeleteProduct));
  }

  Widget listItemsProductsRelations() {
    return ListView.builder(
      itemCount: providerProducts.ltsProductsRelationsByReference.isEmpty
          ? 0
          : providerProducts.ltsProductsRelationsByReference.length >= 5
              ? 5
              : providerProducts.ltsProductsRelationsByReference.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: itemProductRelations(
                providerProducts.ltsProductsRelationsByReference[index],
                openDetailProduct));
      },
    );
  }

  openProductsSave(){
    Navigator.push(
        context,
        customPageTransition(
            ProductsSavePage())).then((value){
              getShopCart();
    });
  }

  openDetailProduct(Product product) {
    providerProducts
        ?.imageReferenceProductSelected = product.references[0]?.images?[0].url ?? "";
    Navigator.push(
        context, customPageTransition(DetailProductPage(product: product)));
  }

  callIsFavorite(Reference reference) {
    if (reference.isFavorite!) {
      removeFavoriteProduct(reference);
    } else {
      saveFavoriteProduct(reference);
    }
  }

  getShopCart() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerShopCart.getShopCart(providerCheckOut.paymentSelected?.id ?? 2);
        await callCart.then((msg) {
          print("finish called shoCar..........");
          if (providerShopCart.shopCart != null) getProductsRelations();
          serviceGetAddAddressUser();
        }, onError: (error) {
         // providerShopCart?.shopCart = null;

        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

  getShippingPrice() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerCheckOut.calculateShippingPrice( providerCheckOut.addressSelected!.id.toString(),providerCheckOut.paymentSelected?.id ?? 2);
        await callCart.then((msg) {
          print("valor $msg");
        }, onError: (error) {
          providerShopCart.isLoadingCart = false;
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

  updateProductCart(int quantity, String idReference) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerShopCart
            .updateQuantityProductCart(idReference, quantity.toString());
        await callCart.then((msg) {
          getShopCart();
          utils.showSnackBarGood(context, msg.toString());
        }, onError: (error) {
          // utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  serviceGetAddAddressUser() async {

    utils.checkInternet().then((value) async {
      if (value) {
        providerCheckOut.isLoading = true;
        Future callResponse = UserProvider.instance.getAddress(context, 0);
        await callResponse.then((user) {
          var decodeJSON = jsonDecode(user);
          GetAddressResponse data = GetAddressResponse.fromJson(decodeJSON);
          var indexAddress = data.data?.addresses?.indexWhere((element) => element.principal ?? false);
          if(indexAddress == -1){
            providerShopCart.hasPrincipalAddress = false;
            utils.showSnackBarError(context, Strings.principalConfigured);
          }else{
            providerShopCart.hasPrincipalAddress = true;
          }
        }, onError: (error) {

          print("Ocurrio un error: $error");
        });
      } else {
        utils.showSnackBarError(context,Strings.loseInternet);
      }
    });
  }



  updateGiftCard(int quantity, String idReference) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart =
            providerShopCart.addGiftCard(idReference, quantity.toString());
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

  addOfferCart(String idOffer, int quantity) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart =
            providerShopCart.addOfferCart(idOffer, quantity.toString(),providerCheckOut.paymentSelected?.id ?? 2);
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

  updateOfferOrProduct(int quantity, String idReference, bool isProduct) {
    if (isProduct) {
      updateProductCart(quantity, idReference);
    } else {
      addOfferCart(idReference, quantity);
    }
  }

  callDeleteProduct(String idProduct) async {
    bool? status = await showDialogDoubleAction(
        context, Strings.delete, Strings.deleteProduct, "ic_trash_big.png",Strings.yesDelete);
    if (status ?? false) deleteProduct(idProduct);
  }

  deleteProduct(String idProduct) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerShopCart.deleteProductCart(idProduct);
        await callCart.then((msg) {
          providerShopCart.shopCart = null;
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

  deleteCart() async {
    if (providerShopCart.shopCart != null) {
      bool? status = await showDialogDoubleAction(
          context, Strings.delete, Strings.deleteCart, "ic_trash_big.png",Strings.yesDelete);
      if (status ?? false)
        utils.checkInternet().then((value) async {
          if (value) {
            Future callCart = providerShopCart.deleteCart();
            await callCart.then((msg) {
              //getShopCart();
              providerShopCart.shopCart = null;
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
  }

  saveProduct(String idReference, String quantity, String idProduct) async {
    bool? state = await utils.startCustomAlertMessage(context, Strings.titleDeleteProduct, "Assets/images/ic_trash_big.png", Strings.deleteProduct,
            ()=>Navigator.pop(context, true), ()=>Navigator.pop(context, false));
   if(state!=null) utils.checkInternet().then((value) async {
      if (value) {
        Future callCart = providerShopCart.saveReference(idReference, quantity);
        await callCart.then((msg) {
          if(state)deleteProduct(idProduct);
          utils.showSnackBarGood(context, msg.toString());
        }, onError: (error) {
          deleteProduct(idProduct);
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
        //providerShopCart.isLoadingCart = true;
        Future callProducts = providerProducts.getProductsRelationByReference(
            pageOffsetProductsRelations,
            providerShopCart
                    .shopCart?.packagesProvider?[0].products?[0].reference?.id
                    ?.toString() ??
                '');
        await callProducts.then((list) {
          serviceGetAddAddressUser();
      //    providerShopCart.isLoadingCart =false;
        }, onError: (error) {
          serviceGetAddAddressUser();
        //  providerShopCart.isLoadingCart =false;
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  saveFavoriteProduct(Reference reference) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerUser.saveAsFavorite(reference.id.toString());
        await callUser.then((msg) {
          providerProducts.ltsProductsRelationsByReference.clear();
          getProductsRelations();
        }, onError: (error) {});
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  removeFavoriteProduct(Reference reference) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerUser.deleteFavorite(reference.id.toString());
        await callUser.then((msg) {
          providerProducts.ltsProductsRelationsByReference.clear();
          getProductsRelations();
        }, onError: (error) {});
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}
