import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/Brand.dart';
import 'package:wawamko/src/Providers/ProviderProducts.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';

import '../../../Utils/utils.dart';
import '../../../Widgets/LoadingProgress.dart';
import '../../../Widgets/WidgetsGeneric.dart';


class FilterBrandsCatalog extends StatefulWidget {
  final Function actionFilter;

  FilterBrandsCatalog({Key? key,required this.actionFilter}) : super(key: key);

  @override
  State<FilterBrandsCatalog> createState() => _FilterBrandsCatalogState();
}

class _FilterBrandsCatalogState extends State<FilterBrandsCatalog> {

  late ProviderProducts providerProducts;
  RefreshController _refreshBrands = RefreshController(initialRefresh: false);
  int pageOffset = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(providerProducts.ltsBrands.isEmpty){
        getBrands();
      }

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerProducts = Provider.of<ProviderProducts>(context);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.2),
      body: SafeArea(
        child: _body(),
      ),
    );
  }

  Widget _body(){
    return Stack(
        children: [
          Row(
            children: [

              SlideInLeft(
                duration: const Duration(milliseconds: 1000),
                child: Container(
                    padding: const EdgeInsets.only(top: 60,left: 20,right: 20,bottom: 27),
                    width: MediaQuery.of(context).size.width * 0.70,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white,
                    child: itemsFilterBrands()
                ),
              ),
              GestureDetector(
                onTap: ()=>Navigator.pop(context),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.30,
                    color: Colors.transparent
                ),
              ),
            ],
          ),
          Visibility(visible: providerProducts.loading, child: LoadingProgress())
        ],
      );
    }


  Widget itemsFilterBrands(){
    return  Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: SmartRefresher(
              controller: _refreshBrands,
              enablePullDown: true,
              enablePullUp: true,
              onLoading: _onLoadingToRefreshBrands,
              footer: footerRefreshCustom(),
              header: headerRefresh(),
               onRefresh: _pullToRefreshBrands,
                child:SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 34.8),
                    Text(
                      Strings.brands,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: Strings.fontMedium
                      ),
                    ),
                    const SizedBox(height: 25),
                    ListView.builder(
                      itemCount: providerProducts.ltsBrands.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context,index){
                        return itemSelectBrand(providerProducts.ltsBrands[index], _selectBrand,providerProducts.brandSelectedCatalog?.id == providerProducts.ltsBrands[index].id);
                      }),
                    const SizedBox(height: 100)

                  ],
                ),
              )),
            ),
          ],
        ),
        Positioned(
          bottom: 25,
          left: 20,
          right: 20,
          child: btnCustom(double.infinity, Strings.clearFilter, CustomColorsAPP.blue3, Colors.white, _clearFilter),
        )
      ],
    );
  }

  _clearFilter(){
    Navigator.pop(context);
    providerProducts.brandSelectedCatalog = null;
    widget.actionFilter();
  }

  _selectBrand(Brand? brand){
    Navigator.pop(context);
    providerProducts.brandSelectedCatalog = brand;
    widget.actionFilter();
  }

  void _pullToRefreshBrands() async {
    await Future.delayed(Duration(milliseconds: 800));
    _clearForRefreshBrands();
    _refreshBrands.refreshCompleted();
  }

  void _clearForRefreshBrands() {
    pageOffset = 0;
    providerProducts.ltsBrands.clear();
    getBrands();
  }

  void _onLoadingToRefreshBrands() async {
    await Future.delayed(Duration(milliseconds: 800));
    pageOffset++;
    getBrands();
    _refreshBrands.loadComplete();
  }

  getBrands() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callProducts = providerProducts.getBrands(pageOffset);
        await callProducts.then((list) {}, onError: (error) {
          providerProducts.isLoadingProducts = false;
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  }





