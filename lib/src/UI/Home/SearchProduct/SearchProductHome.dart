import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/Product/Product.dart';
import 'package:wawamko/src/Providers/ProviderProducts.dart';
import 'package:wawamko/src/UI/Home/Products/DetailProductPage.dart';
import 'package:wawamko/src/UI/Home/SearchProduct/CommentProductNotFound.dart';
import 'package:wawamko/src/UI/Home/SearchProduct/Widgets.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';



class SearchProductHome extends StatefulWidget {
  final String textSearch;

  const SearchProductHome({required this.textSearch});
  @override
  _SearchProductHomeState createState() => _SearchProductHomeState();
}

class _SearchProductHomeState extends State<SearchProductHome> {
  final searchController = TextEditingController();
  late ProviderProducts providerProducts;
  int pageOffset = 0;

  @override
  void initState() {
    searchController.text = widget.textSearch;
    providerProducts = Provider.of<ProviderProducts>(context,listen: false);
    providerProducts.ltsProductsSearch.clear();
    if(widget.textSearch.isNotEmpty) {
      getProducts(widget.textSearch);
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    providerProducts = Provider.of<ProviderProducts>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                children: [

                  header(context, Strings.searcher, CustomColors.redDot, ()=>Navigator.pop(context)),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                      child: boxSearch(searchController, callSearchProducts)),
                  providerProducts.ltsProductsSearch.isEmpty
                      ? Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            child: emptyDataWithAction("ic_ups.png",Strings.sorrySearch,
                            Strings.emptySearchProducts,Strings.send,openViewSendComment),
                          ),
                        ),
                      ):Expanded(
                    child: SingleChildScrollView(
                      child: Container(
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
                            return itemProductSearch(providerProducts.ltsProductsSearch[index], openDetailProduct);
                          },
                        ),
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
    providerProducts.ltsProductsSearch.clear();
    if(value.isNotEmpty) {
      getProducts(value);
    }
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

  openViewSendComment(){
    Navigator.push(context, customPageTransition(CommentProductNotFound()));
  }

  openDetailProduct(Product product){
    String? color = product.references[0].color;

    print("producto y color buscar $color ${product.references[0].images?.length}");
    if(product.references[0].images?.length != 0)
    {
      if (color != null  && color.startsWith('#') && color.length >= 6) {
        providerProducts?.imageReferenceProductSelected = product.references[0]?.images?[0].url ?? "";
        Navigator.push(context, customPageTransition(DetailProductPage(product: product)));
      }
    }
  }
}