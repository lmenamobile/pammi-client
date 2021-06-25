import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/Product/Reference.dart';
import 'package:wawamko/src/Providers/ProviderProducts.dart';
import 'package:wawamko/src/Utils/colors.dart';

import 'Widgets.dart';

class PhotosProductPage extends StatefulWidget {
  final Reference productReference;

  const PhotosProductPage({@required this.productReference});
  @override
  _PhotosProductPageState createState() => _PhotosProductPageState();
}

class _PhotosProductPageState extends State<PhotosProductPage> {
  Reference reference;
  ProviderProducts providerProducts;
  @override
  void initState() {
    reference = widget.productReference;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerProducts = Provider.of<ProviderProducts>(context);
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(.5),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.bottomRight,
                child: IconButton(icon: Icon(Icons.close,color: Colors.white,), onPressed: ()=>Navigator.pop(context))),
            Expanded(child:  zoomImage(context,providerProducts
                ?.imageReferenceProductSelected ??
                ''))

          ],
        ),
      ),
    );
    /*return Scaffold(
      backgroundColor: CustomColors.redTour,
      body: SafeArea(
        child:Container(
          color: CustomColors.whiteBackGround,
          child: Column(
            children: [
              titleBarWithDoubleAction(
                  reference?.reference??'',
                  "ic_blue_arrow.png",
                  "ic_car.png",
                      () => Navigator.pop(context),
                  null),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    sliderImages(
                      providerProducts.indexSliderImages,updateIndexSliderImages,reference.images
                    ),
                ],),
              )
            ],
          ),
        ),
      ),
    );*/
  }


  updateIndexSliderImages(int index) {
    providerProducts.indexSliderImages = index;
  }
}