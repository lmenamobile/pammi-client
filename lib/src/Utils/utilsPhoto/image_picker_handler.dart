import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'image_picker_dialog.dart';

class ImagePickerHandler {
  late ImagePickerDialog imagePicker;
  AnimationController? _controller;
  ImagePickerListener _listener;


  final ImagePicker _picker = ImagePicker();


  ImagePickerHandler(this._listener, this._controller);

  openCamera() async {
    imagePicker.dismissDialog();
    //var image = await _picker.pickImage(source: ImageSource.camera);
    var image = await ImagePicker.platform.pickImage(source: ImageSource.camera);
    cropImage(File(image?.path??''));
  }



  openGallery() async {
    imagePicker.dismissDialog();
   // var image = await ImagePicker().pla//_picker.pickImage(source: ImageSource.gallery);
    var image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    cropImage(File(image?.path??''));
  }

  void init() {
    imagePicker = new ImagePickerDialog(this, _controller);
    imagePicker.initState();
  }



  Future cropImage(File image) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      maxWidth: 512,
      maxHeight: 512,
    );
    if(croppedFile == null) return;
    _listener.userImage(File(croppedFile.path));
  }

  showDialog(BuildContext context) {
    imagePicker.getImage(context);
  }
}

abstract class ImagePickerListener {
  userImage(File? _image);
}
