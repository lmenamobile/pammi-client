import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Providers/ProviderFilter.dart';
import '../../../Utils/Strings.dart';
import '../../../config/theme/colors.dart';

class FilterBrandWidget extends StatelessWidget {

  late ProviderFilter providerFilter;

  @override
  Widget build(BuildContext context) {
    providerFilter = Provider.of<ProviderFilter>(context);
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: AppColors.gray2,
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        iconColor: AppColors.blue,
        collapsedIconColor: AppColors.blue,
        title: Text(
          Strings.brands,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.blueSplash,
            fontFamily: Strings.fontBold,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              style: TextStyle(
                color: AppColors.blue,
                fontFamily: Strings.fontRegular,
              ),
              decoration: InputDecoration(
                hintText: 'Buscar...',
                hintStyle: TextStyle(
                  color: AppColors.gray,
                  fontFamily: Strings.fontRegular,
                  fontStyle: FontStyle.italic,
                ),
                prefixIcon: Icon(Icons.search, color: AppColors.blue),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(26.0)),
                  borderSide: BorderSide(color: AppColors.greyBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(26.0)),
                  borderSide: BorderSide(color: AppColors.greyBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(26.0)),
                  borderSide: BorderSide(color: AppColors.greyBorder),
                ),
              ),
              onChanged: (query) {
                providerFilter.filterBrands(query);
              },
            ),
          ),
          ...providerFilter.filteredBrands.map((brand) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(brand.image ?? ''),
                radius: 20,
              ),
              title: Text(brand.brand ?? '',
                  style: TextStyle(
                    color: AppColors.blue,
                    fontFamily: Strings.fontRegular,
                  )),
            );
          }).toList(),
        ],
      ),
    );
  }
}