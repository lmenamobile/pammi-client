import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/ProviderOder.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class QualificationPage extends StatefulWidget {
  final String? subOrderId, idQualification,data;
  final int optionView;
  const QualificationPage(
      {required this.optionView,required this.subOrderId, required this.idQualification,this.data});

  @override
  _QualificationPageState createState() => _QualificationPageState();
}

class _QualificationPageState extends State<QualificationPage> {
  ProviderOrder? providerOrder;
  var valueRating = '1';
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    providerOrder = Provider.of<ProviderOrder>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            header(context, Strings.qualification, CustomColors.redDot, () => Navigator.pop(context)),
            changeViewWidget(widget.optionView)
          ],
        ),
      ),
    );
  }

  Widget changeViewWidget(int option) {
    switch (option) {
      case 0:
        return qualificationProvider();

      case 1:
        return viewQualificationProduct();

      case 2:
        return viewQualificationSeller();

      default:
        return qualificationProvider();
    }
  }

  Widget qualificationProvider() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "Assets/images/ic_star2x.png",
              width: 100,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                Strings.textQualification,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: Strings.fontBold,
                    fontSize: 17,
                    color: CustomColors.blackLetter),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              Strings.brands,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: Strings.fontRegular, color: CustomColors.gray7),
            ),
            listImagesBrands(),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 250,
              child: RatingBar.builder(
                initialRating: 1,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 40,
                glowColor: Colors.amber,
                unratedColor: Colors.amber.withOpacity(.3),
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  valueRating = rating.toString();
                },
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Expanded(
                      child: btnCustom(
                          double.infinity,
                          Strings.skip,
                          CustomColors.gray5,
                          CustomColors.blackLetter,
                          () => Navigator.pop(context))),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: btnCustom(
                          double.infinity,
                          Strings.send,
                          CustomColors.blue,
                          Colors.white,
                          () => {qualificationUserProvider()})),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget viewQualificationProduct() {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20),
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 90,
                height: 90,
                child: isImageYoutube(widget.data??'', FadeInImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(widget.data??''),
                  placeholder: AssetImage("Assets/images/spinner.gif"),
                  imageErrorBuilder: (_,__,___){
                    return Container();
                  },
                )),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  Strings.countStar,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: Strings.fontBold,
                      fontSize: 17,
                      color: CustomColors.blackLetter),
                ),
              ),
              customDivider(),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 250,
                child: RatingBar.builder(
                  initialRating: 1,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 40,
                  glowColor: Colors.amber,
                  unratedColor: Colors.amber.withOpacity(.3),
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    valueRating = rating.toString();
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                Strings.commentProduct,
                style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    color: CustomColors.blackLetter),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                width: double.infinity,
                height: 145,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: CustomColors.gray.withOpacity(.2),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: Offset(0, .5),
                      )
                    ]),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextField(
                    textInputAction: TextInputAction.done,
                    controller: commentController,
                    maxLines: 5,
                    maxLength: 100,
                    textAlign: TextAlign.justify,
                    inputFormatters: [],
                    style: TextStyle(
                        fontFamily: Strings.fontRegular,
                        color: CustomColors.gray7),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: Strings.hintComment,
                      hintStyle: TextStyle(
                          fontFamily: Strings.fontRegular,
                          color: CustomColors.gray5),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Expanded(
                        child: btnCustom(
                            double.infinity,
                            Strings.skip,
                            CustomColors.gray5,
                            CustomColors.blackLetter,
                            () => Navigator.pop(context))),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: btnCustom(
                            double.infinity,
                            Strings.send,
                            CustomColors.blue,
                            Colors.white,
                            () => {qualificationProduct()})),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget viewQualificationSeller() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              child: FadeInImage(
                fit: BoxFit.fill,
                image: NetworkImage(widget.data??''),
                placeholder: AssetImage("Assets/images/spinner.gif"),
                imageErrorBuilder: (_,__,___){
                  return Container();
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                Strings.qualificationSeller,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: Strings.fontBold,
                    fontSize: 17,
                    color: CustomColors.blackLetter),
              ),
            ),
            customDivider(),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 250,
              child: RatingBar.builder(
                initialRating: 1,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 40,
                glowColor: Colors.amber,
                unratedColor: Colors.amber.withOpacity(.3),
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  valueRating = rating.toString();
                },
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Expanded(
                      child: btnCustom(
                          double.infinity,
                          Strings.skip,
                          CustomColors.gray5,
                          CustomColors.blackLetter,
                          () => Navigator.pop(context))),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: btnCustom(
                          double.infinity,
                          Strings.send,
                          CustomColors.blue,
                          Colors.white,
                          () => {qualificationSeller()})),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget listImagesBrands() {
    return Container(
      height: 100,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        itemCount: providerOrder?.lstImagesBrands==null?0:providerOrder!.lstImagesBrands.length,
        itemBuilder: (_, int index) {
          return CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50)),
                child: Image.network(providerOrder!.lstImagesBrands[index]!)),
          );
        },
      ),
    );
  }

  qualificationUserProvider() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callOrders = providerOrder!.qualificationProvider(
            widget.idQualification, valueRating, widget.subOrderId);
        await callOrders.then((msg) {
          Navigator.pop(context);
          utils.showSnackBarGood(context, msg);
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  qualificationProduct() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callOrders = providerOrder!.qualificationProduct(
            widget.idQualification,
            valueRating,
            widget.subOrderId,
            commentController.text.toString());
        await callOrders.then((msg) {
          Navigator.pop(context);
          utils.showSnackBarGood(context, msg);
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  qualificationSeller() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callOrders = providerOrder!.qualificationSeller(widget.idQualification, valueRating, widget.subOrderId);
        await callOrders.then((msg) {
          Navigator.pop(context);
          utils.showSnackBarGood(context, msg);
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}
