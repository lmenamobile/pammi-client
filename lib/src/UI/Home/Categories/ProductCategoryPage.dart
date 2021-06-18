import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/Product/Product.dart';
import 'package:wawamko/src/Providers/ProviderProducts.dart';
import 'package:wawamko/src/UI/Home/Categories/Widgets.dart';
import 'package:wawamko/src/UI/Home/Products/DetailProductPage.dart';
import 'package:wawamko/src/UI/Home/Widgets.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

class ProductCategoryPage extends StatefulWidget {
  final String idCategory, idSubcategory;

  const ProductCategoryPage({@required this.idCategory,@required this.idSubcategory});
  @override
  _ProductCategoryPageState createState() => _ProductCategoryPageState();
}

class _ProductCategoryPageState extends State<ProductCategoryPage> {
  final searchController = TextEditingController();
  ProviderProducts providerProducts;
  int pageOffset = 0;

  @override
  void initState() {
    providerProducts = Provider.of<ProviderProducts>(context,listen: false);
    providerProducts.ltsProductsByCategory.clear();
    getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerProducts = Provider.of<ProviderProducts>(context);
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      body: SafeArea(
        child: Container(
          color: CustomColors.grayBackground,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[CustomColors.redTour, CustomColors.redOne],
                      ),
                    ),
                    child: Container(
                      height: 100,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  child: Image(
                                    image: AssetImage(
                                        "Assets/images/ic_backward_arrow.png"),
                                  ),
                                ),
                                onTap: () => Navigator.pop(context),
                              ),
                              Text(
                                Strings.categories,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontFamily: Strings.fontBold),
                              ),
                              GestureDetector(
                                child: Container(
                                  width: 30,
                                  child: Image(
                                    image: AssetImage("Assets/images/ic_car.png"),
                                  ),
                                ),
                                onTap: null,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                    child: boxSearchHome(searchController, null)),
                                SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.menu,
                                      color:
                                          CustomColors.graySearch.withOpacity(.3),
                                    ),
                                    onPressed: null)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
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
                      itemCount: providerProducts.ltsProductsByCategory.isEmpty?0:
                      providerProducts.ltsProductsByCategory.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return itemProductCategory(providerProducts.ltsProductsByCategory[index],openDetailProduct);
                      },
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

  openDetailProduct(Product product){
    Navigator.push(context, customPageTransition(DetailProductPage(product: product)));
  }

  getProducts() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callProducts = providerProducts.getProductsByCategory("", pageOffset, null, widget.idCategory, widget.idSubcategory, null, null);
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
