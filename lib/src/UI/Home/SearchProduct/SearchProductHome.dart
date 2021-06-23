import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/ProviderProducts.dart';
import 'package:wawamko/src/UI/Home/SearchProduct/Widgets.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

class SearchProductHome extends StatefulWidget {
  final String textSearch;

  const SearchProductHome({@required this.textSearch});
  @override
  _SearchProductHomeState createState() => _SearchProductHomeState();
}

class _SearchProductHomeState extends State<SearchProductHome> {
  final searchController = TextEditingController();
  ProviderProducts providerProducts;
  int pageOffset = 0;

  @override
  void initState() {
    searchController.text = widget.textSearch;
    providerProducts = Provider.of<ProviderProducts>(context,listen: false);
    providerProducts.ltsProductsSearch.clear();
    getProducts(widget.textSearch);
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
          child: Stack(
            children: [
              Column(
                children: [
                  titleBar(Strings.searcher,"ic_blue_arrow.png", ()=>Navigator.pop(context)),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                              child: boxSearch(searchController, callSearchProducts)),
                          Container(
                            child: GridView.builder(
                              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                childAspectRatio: .77,
                                crossAxisSpacing: 15,
                              ),
                              padding: EdgeInsets.only(top: 20,bottom: 10,left: 10,right: 10),
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: providerProducts.ltsProductsSearch.isEmpty?0:
                              providerProducts.ltsProductsSearch.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return itemProductSearch(providerProducts.ltsProductsSearch[index], null);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )

                ],
              ),
              Visibility(
                  visible: providerProducts.isLoadingProducts, child: LoadingProgress()),
            ],
          ),
        ),
      ),
    );
  }

  callSearchProducts(String value){
    FocusScope.of(context).unfocus();
    getProducts(value);
  }

  getProducts(String search) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callProducts = providerProducts.getProductsSearch(search, pageOffset, null, null, null, null, null);
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