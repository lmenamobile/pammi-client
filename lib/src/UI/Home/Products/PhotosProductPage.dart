import 'package:flutter/material.dart';


import 'Widgets.dart';

class PhotosProductPage extends StatefulWidget {
  final String? image;

  const PhotosProductPage({required this.image});
  @override
  _PhotosProductPageState createState() => _PhotosProductPageState();
}

class _PhotosProductPageState extends State<PhotosProductPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.black.withOpacity(.5),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.bottomRight,
                child: IconButton(icon: Icon(Icons.close,color: Colors.white,), onPressed: ()=>Navigator.pop(context))),
            Expanded(child:  zoomImage(context,widget.image ??
                ''))

          ],
        ),
      ),
    );
  }

}