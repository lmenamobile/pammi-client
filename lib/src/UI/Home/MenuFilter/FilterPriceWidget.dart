import 'package:flutter/material.dart';

import '../../../Utils/Strings.dart';
import '../../../Utils/colors.dart';

class FilterPriceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color selectedColor = CustomColorsAPP.blue;
    Color unselectedColor = CustomColorsAPP.gray6;
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: CustomColorsAPP.gray2,
      ),
      child:ExpansionTile(
        initiallyExpanded: true,
        iconColor: CustomColorsAPP.blue,
        collapsedIconColor: CustomColorsAPP.blue,
        title: Text(
            Strings.price,
            style: TextStyle(
                color: CustomColorsAPP.blueSplash,
                fontSize: 16,
                fontFamily: Strings.fontBold)
        ),
        children: [
          Wrap(
            spacing: 8.0,
            children: [r'$0 - $50.000', r'$50.000 - $200.000', r'$200.000 - $500.000', r'$1´000.000 o más'].map((price) {
              return ChoiceChip(
                checkmarkColor: CustomColorsAPP.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: r'$50.000 - $200.000' == price ? selectedColor : unselectedColor,)
                ),
                label: Text(price,
                    style: TextStyle(
                        color: r'$50.000 - $200.000' == price ? selectedColor : unselectedColor
                    )
                ),
                selected: r'$50.000 - $200.000' == price,
                selectedColor: selectedColor.withOpacity(.2),
                backgroundColor: unselectedColor.withOpacity(0.1),
                onSelected: (selected) {
                 // filtroProvider.setTalla(selected ? talla : '');
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}