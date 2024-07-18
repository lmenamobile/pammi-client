import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:wawamko/src/UI/Home/MenuFilter/FilterBrandWidget.dart';
import 'package:wawamko/src/UI/Home/MenuFilter/FilterSubcategoryWidget.dart';

import 'package:wawamko/src/config/theme/colors.dart';

import '../../../Providers/ProviderHome.dart';
import '../../../Providers/ProviderFilter.dart';
import '../../../Utils/Strings.dart';
import 'FilterColorWidget.dart';
import 'FilterMaterialWidget.dart';
import 'FilterPriceWidget.dart';
import 'FilterSizeWidget.dart';

class MenuFilterView extends StatefulWidget {
  @override
  State<MenuFilterView> createState() => _MenuFilterViewState();
}

class _MenuFilterViewState extends State<MenuFilterView> {
  late ProviderHome providerHome;
  late ProviderFilter providerFilter;

  @override
  void initState() {
    providerHome = Provider.of<ProviderHome>(context, listen: false);
    providerFilter = Provider.of<ProviderFilter>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      providerFilter.setBrands(providerHome.ltsBrands);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              //HEADER
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.filterBy,
                    style: TextStyle(
                        color: AppColors.blueSplash,
                        fontSize: 16,
                        fontFamily: Strings.fontBold),
                  ),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: AppColors.blue,
                      ))
                ],
              ),
              Text(
                Strings.clearFilter,
                style: TextStyle(
                  color: AppColors.blue,
                  fontFamily: Strings.fontRegular,
                ),
              ),
              SizedBox(height: 10,),
              //BRANDS
              FilterBrandWidget(),
              SizedBox(height: 10,),
              //CATEGORIES AND SUBCATEGORIES
              FilterSubcategoryWidget(),
              SizedBox(height: 10,),
              //SIZES
              FilterSizeWidget(),
              SizedBox(height: 10,),
               //MATERIALS
              FilterMaterialWidget(),
              SizedBox(height: 10,),
              //COLORS
              FilterColorWidget(),
              SizedBox(height: 10,),
              //PRICES
              FilterPriceWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
