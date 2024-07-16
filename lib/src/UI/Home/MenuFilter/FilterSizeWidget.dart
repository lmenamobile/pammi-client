import 'package:flutter/material.dart';

import '../../../Utils/Strings.dart';
import '../../../Utils/colors.dart';

class FilterSizeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color selectedColor = CustomColorsAPP.blue;
    Color unselectedColor = CustomColorsAPP.gray6;
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: CustomColorsAPP.gray2,
      ),child:ExpansionTile(
        initiallyExpanded: true,
        iconColor: CustomColorsAPP.blue,
        collapsedIconColor: CustomColorsAPP.blue,
        title: Text(
            Strings.size,
            style: TextStyle(
                color: CustomColorsAPP.blueSplash,
                fontSize: 16,
                fontFamily: Strings.fontBold)
        ),
        children: [
          Wrap(
            spacing: 8.0,
            children: ['XS', 'S', 'M', 'L', 'XL'].map((size) {
              return ChoiceChip(
                checkmarkColor: CustomColorsAPP.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color:"S" == size ? selectedColor : unselectedColor,)
                ),
                label: Text(size,
                    style: TextStyle(
                        color: 'S' == size ? selectedColor : unselectedColor
                    )
                ),
                selected: 'S'== size,
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
