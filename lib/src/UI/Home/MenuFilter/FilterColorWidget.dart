import 'package:flutter/material.dart';

import '../../../Utils/Strings.dart';
import '../../../Utils/colors.dart';

class FilterColorWidget extends StatelessWidget {
  final List<Color> colores = [
    Colors.grey,
    Colors.black,
    Colors.purple,
    Colors.red,
    Colors.grey.shade300,
    Colors.yellow,
    Colors.blue,
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: CustomColorsAPP.gray2,
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        iconColor: CustomColorsAPP.blue,
        collapsedIconColor: CustomColorsAPP.blue,
        title: Text(
            Strings.color,
            style: TextStyle(
                color: CustomColorsAPP.blueSplash,
                fontSize: 16,
                fontFamily: Strings.fontBold)
        ),
        children: [
          Wrap(
        spacing: 8.0,
        children: colores.map((color) {
          return ChoiceChip(
            showCheckmark: false,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color:  Colors.purple.toString()  == color.toString() ? color:color.withOpacity(0.3),
                width: Colors.purple.toString()  == color.toString() ? 2.0 : 1.0,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            label: Text(''), // Empty label as we are using avatar for color
            selected: Colors.purple.toString() == color.toString(),
            selectedColor: Colors.purple.toString()  == color.toString() ? color:color.withOpacity(0.5), // Change if needed
            backgroundColor: color.withOpacity(0.3), // Change if needed
            onSelected: (selected) {
              //filtroProvider.setColor(selected ? color.toString() : '');
            },
          );
        }).toList(),
      ),
        ],
      ),
    );
  }
}
