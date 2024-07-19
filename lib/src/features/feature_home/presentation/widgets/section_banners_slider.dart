import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import '../../../../config/config.dart';
import '../../../feature_views_shared/domain/domain.dart';

class SectionBannersSlider extends StatelessWidget {
  final int indexBanner;
  final List<Banners> banners;
  final Function updateBannerIndex;

  const SectionBannersSlider({
    Key? key,
    required this.indexBanner,
    required this.banners,
    required this.updateBannerIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: banners.isNotEmpty,
      child: Column(
        children: [
          CarouselSlider.builder(
            itemCount: banners.isEmpty?0:banners.length,
            itemBuilder: (_, int itemIndex, int pageViewIndex) =>
                FadeInImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(banners[itemIndex].image??''),
                  placeholder: AssetImage("Assets/images/preloader.gif"),
                  imageErrorBuilder: (_,__,___){
                    return Container();
                  },
                ), options: CarouselOptions(
              height: 208,
              viewportFraction: 1,
              autoPlay: true,
              autoPlayAnimationDuration: Duration(seconds: 4),
              onPageChanged: (index,changeType){
                updateBannerIndex(index);
              }
          ),
          ),

          banners.isEmpty?Container():Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
            child: DotsIndicator(
              dotsCount: banners.length,
              position: indexBanner,
              decorator: DotsDecorator(
                activeColor: AppColors.blue5,
                size: const Size.square(9),
                spacing: const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
                activeSize: const Size(9, 9),
                activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
          )
        ],
      ),
    );
  }
}