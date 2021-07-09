import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/Product/Product.dart';
import 'package:wawamko/src/Models/Product/Reference.dart';
import 'package:wawamko/src/Providers/ProviderProducts.dart';
import 'package:wawamko/src/UI/Home/Categories/Widgets.dart';
import 'package:wawamko/src/UI/Home/Products/PhotosProductPage.dart';
import 'package:wawamko/src/UI/Home/Products/Widgets.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/ExpansionWidget.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

class DetailProductPage extends StatefulWidget {
  final Product product;

  const DetailProductPage({@required this.product});

  @override
  _DetailProductPageState createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  ProviderProducts providerProducts;

  @override
  void initState() {
    providerProducts = Provider.of<ProviderProducts>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      providerProducts.productDetail = widget.product;
      providerProducts.referenceProductSelected = providerProducts.referenceProductSelected??widget.product.references[0];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerProducts = Provider.of<ProviderProducts>(context);

    return Scaffold(
      backgroundColor: CustomColors.redTour,
      body: SafeArea(
        child: Container(
          color: CustomColors.whiteBackGround,
          child: Column(
            children: [
              titleBarWithDoubleAction(
                  widget.product.product,
                  "ic_blue_arrow.png",
                  "ic_car.png",
                  () => Navigator.pop(context),
                  null),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 290,
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
                              onTap: ()=>openZoomImages(),
                              child: imageReference(
                                  170,
                                  providerProducts
                                          ?.imageReferenceProductSelected ??
                                      ''),
                            ),
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
                                onTap: ()=>openBottomSheetLtsReferences(context, setReference,providerProducts?.ltsReferencesProductSelected),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: CustomColors.gray6,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 23, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          children: [
                                            itemImageReference(
                                                35,
                                                providerProducts
                                                        ?.referenceProductSelected
                                                        ?.images[0]
                                                        .url ??
                                                    ''),
                                            SizedBox(
                                              width: 13,
                                            ),
                                            Text(
                                              providerProducts
                                                      ?.referenceProductSelected
                                                      ?.reference ??
                                                  '',
                                              style: TextStyle(
                                                  fontFamily: Strings.fontRegular,
                                                  color: CustomColors.gray7),
                                            )
                                          ],
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
                                    color: CustomColors.blackLetter),
                              ),
                              rowStars(double.parse(providerProducts
                                      ?.referenceProductSelected
                                      ?.qualification ??
                                  '0')),
                              Text(
                                formatMoney(providerProducts
                                        ?.referenceProductSelected?.price ??
                                    '0'),
                                style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: Strings.fontMedium,
                                    color: CustomColors.orange),
                              ),
                              rowButtonsMoreAndLess(),
                              customDivider(),
                              Row(
                                children: [
                                  Image.asset(
                                    "Assets/images/ic_address_green.png",
                                    width: 30,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "A ca falta el tipo de entrega",
                                    style: TextStyle(
                                        fontFamily: Strings.fontRegular,
                                        color: CustomColors.blackLetter),
                                  )
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    btnCustom(
                                        120,
                                        Strings.paymentNow,
                                        CustomColors.orange,
                                        Colors.white,
                                        null),
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
                                            null),
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
                ),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customDivider(),
                  ],
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
              onTap: () => setImageReference(providerProducts
                  ?.referenceProductSelected?.images[index].url),
              child: itemImageReference(
                  50,
                  providerProducts
                      ?.referenceProductSelected?.images[index].url)),
        );
      },
    );
  }

  setImageReference(String asset) {
    providerProducts?.imageReferenceProductSelected = asset;
  }

  setReference(Reference reference){
    providerProducts?.referenceProductSelected = reference;
    providerProducts?.productDetail?.references?.forEach((element) {
      if(element!=reference){
        element.isSelected = false;
      }
    });
    Navigator.pop(context);
  }

  openZoomImages(){
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __)=>PhotosProductPage(productReference: providerProducts?.referenceProductSelected,)));
  }

}
