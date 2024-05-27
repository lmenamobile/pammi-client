import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:wawamko/src/Models/Product/CommentProduct.dart';
import 'package:wawamko/src/Models/Product/ImageProduct.dart';
import 'package:wawamko/src/Models/Product/Reference.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

/*Widget titleBarWithDoubleAction(String title, String icon, String iconTwo,
    Function action, Function actionTwo, bool isIconCart,String totalProducts) {
  return Container(
    width: double.infinity,
    height: 75,
    decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("Assets/images/ic_header_reds.png"),
            fit: BoxFit.fill)),
    child: Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            height: 15,
            decoration: BoxDecoration(
                color: CustomColors.whiteBackGround,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15),
                )
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              child: Image(
                width: 40,
                height: 40,
                color: Colors.white,
                image: AssetImage("Assets/images/$icon"),
              ),
              onTap: () => action(),
            ),
            Expanded(
              child: Center(
                child: Container(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: Strings.fontRegular,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 10),
              child: GestureDetector(
                child: isIconCart?Stack(
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
                        visible: totalProducts!="0"?true:false,
                        child: CircleAvatar(
                          radius: 6,
                          backgroundColor: Colors.white,
                          child: Text(
                            totalProducts,
                            style: TextStyle(
                                fontSize: 8,
                                color: CustomColors.redTour
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ):Image(
                  width: 40,
                  height: 40,
                  color: Colors.white,
                  image: AssetImage("Assets/images/$iconTwo"),
                ),
                onTap: () => actionTwo(),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}*/

Widget itemImageReference(Size size, String asset,String assetSelected) {
  return Container(
    width: size.width,
    height: size.height,
    decoration: BoxDecoration(
      border: Border.all(
          color: asset==assetSelected?CustomColorsAPP.gray7:CustomColorsAPP.gray4,
          width: asset==assetSelected?1.5:1
      ),
    ),
    child: asset.isEmpty?Image.asset("Assets/images/spinner.gif"):
    isImageYoutube(asset,FadeInImage(
      fit: BoxFit.fill,
      image: NetworkImage(asset),
      placeholder: AssetImage("Assets/images/spinner.gif"),
      imageErrorBuilder: (_,__,___){
        return Container();
      },
    ),
    ),
  );
}

Widget imageReference(Size size, String asset){
  return Container(
    width: size.width,
    height: size.height,
    child: FadeInImage(
      fit: BoxFit.fill,
      image: NetworkImage(asset),
      placeholder: AssetImage("Assets/images/spinner.gif"),
      imageErrorBuilder: (_,__,___){
        return Container();
      },
    ),
  );
}

Widget itemReference(String asset,String nameReference, bool isSelected){
  return Container(
    decoration: BoxDecoration(
        color: isSelected?CustomColorsAPP.grayBackground:Colors.transparent,
        borderRadius:
        BorderRadius.all(Radius.circular(5))),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            child:asset.isEmpty?Image.asset("Assets/images/spinner.gif"): isImageYoutube(asset,FadeInImage(
              fit: BoxFit.fill,
              image: NetworkImage(asset),
              placeholder: AssetImage("Assets/images/spinner.gif"),
              imageErrorBuilder: (_,__,___){
                return Container();
              },
            )),
          ),
          SizedBox(
            width: 13,
          ),
          Expanded(
            child: Text(
              nameReference,
              maxLines: 2,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                  fontFamily: Strings.fontRegular,
                  color: CustomColorsAPP.gray7),
            ),
          )
        ],
      ),
    ),
  );
}

 zoomImage(BuildContext context,String image){
  return PhotoView(
    backgroundDecoration: BoxDecoration(
        color: Colors.transparent
    ),
    heroAttributes: PhotoViewHeroAttributes(tag: image),
    initialScale:  PhotoViewComputedScale.covered,
    customSize: Size(MediaQuery.of(context).size.width, 300),
    minScale: PhotoViewComputedScale.covered,
    maxScale: PhotoViewComputedScale.covered*3.0,
    imageProvider: NetworkImage(image),
  );
}

Widget sliderImages(int indexSlider,Function updateIndex, List<ImageProduct> images){
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 300,
        height: 300,
        child: CarouselSlider.builder(
          itemCount: images.isEmpty?0:images.length,
          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex){
            return zoomImage(context, images.isEmpty?"http://via.placeholder.com/200x150":images[itemIndex].url!);
          },
          options: CarouselOptions(
            autoPlay: false,
              onPageChanged: (index,changeType){
                updateIndex(index);
              }
          ),
        ),
      ),
      SizedBox(height: 20,),
      images.isEmpty?Container():DotsIndicator(
        dotsCount: images.length,
        position: indexSlider,
        decorator: DotsDecorator(
          activeColor: CustomColorsAPP.orange,
          size: const Size.square(9),
          spacing: const EdgeInsets.symmetric(horizontal: 2,vertical: 4),
          activeSize: const Size(30, 9),
          activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
      )
    ],
  );
}

openBottomSheetLtsReferences(BuildContext context,Function selectReference,List<Reference>? ltsReferences) {
  return showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      isScrollControlled: true,
      enableDrag: true,
      barrierColor: CustomColorsAPP.blueSplash.withOpacity(.6),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height*.65,
          decoration: BoxDecoration(
            color: CustomColorsAPP.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25,horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
               Text(
                 Strings.references,
                 style: TextStyle(
                   overflow: TextOverflow.ellipsis,
                   fontFamily: Strings.fontBold,
                   fontSize: 18,
                   color:CustomColorsAPP.black1
                 ),
               ),
                SizedBox(height: 15,),
                Expanded(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 10,bottom: 10),
                      itemCount: ltsReferences==null?0:ltsReferences.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (_, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: InkWell(
                            onTap: (){
                              selectReference(ltsReferences?[index]);
                            },
                              child: itemReference(ltsReferences![index].images!.isEmpty?'':
                                  ltsReferences[index].images![0].url!, ltsReferences[index].reference!,ltsReferences[index].isSelected!)),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Visibility(
                  visible: false,
                  child: btnCustom(
                      190,
                      Strings.next,
                      CustomColorsAPP.blueSplash,
                      Colors.white,
                      null),
                ),
              ],
            ),
          ),
        );
      });
}

itemComment(CommentProduct commentProduct){
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      color: CustomColorsAPP.whiteBackGround
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 50,
            width: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: Image.network(commentProduct.user?.photoUrl??''),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  commentProduct.user?.fullName??'',
                  style: TextStyle(
                    color: CustomColorsAPP.blue,
                    fontSize: 13,
                    fontFamily: Strings.fontRegular
                  ),
                ),
                Text(
                  commentProduct.comment??'',
                  maxLines: 2,
                  style: TextStyle(
                      color: CustomColorsAPP.gray7,
                      fontSize: 13,
                      fontFamily: Strings.fontRegular
                  ),
                ),
                Text(
                  formatDate(commentProduct.date??DateTime.now(), "dd-MM-yyyy", "es_CO"),
                  style: TextStyle(
                      color: CustomColorsAPP.gray7,
                      fontSize: 13,
                      fontFamily: Strings.fontRegular
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

