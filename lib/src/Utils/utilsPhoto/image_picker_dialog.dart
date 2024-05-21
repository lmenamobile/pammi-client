import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:animate_do/animate_do.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import '../../Widgets/Dialogs/dialogPermissionGallery.dart';
import 'image_picker_handler.dart';

class ImagePickerDialog extends StatelessWidget {
  ImagePickerHandler _listener;
  AnimationController? _controller;
  late BuildContext context;

  ImagePickerDialog(this._listener, this._controller);

  Animation<double>? _drawerContentsOpacity;
  Animation<Offset>? _drawerDetailsPosition;

  bool statePermissionsPhotos = false;
  bool statePermissionsGallery = false;

  void initState() {
    _drawerContentsOpacity = new CurvedAnimation(
      parent: new ReverseAnimation(_controller!),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = new Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(new CurvedAnimation(
      parent: _controller!,
      curve: Curves.fastOutSlowIn,
    ));
  }

  getImage(BuildContext context) {
    if (_controller == null ||
        _drawerDetailsPosition == null ||
        _drawerContentsOpacity == null) {
      return;
    }
    _controller!.forward();
    showDialog(
      context: context,
      builder: (BuildContext context) => new SlideTransition(
        position: _drawerDetailsPosition!,
        child: new FadeTransition(
          opacity: new ReverseAnimation(_drawerContentsOpacity!),
          child: this,
        ),
      ),
    );
  }

  void dispose() {
    _controller!.dispose();
  }

  startTime() async {
    var _duration = new Duration(milliseconds: 200);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pop(context);
  }

  dismissDialog() {
    _controller!.reverse();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Material(
        type: MaterialType.transparency,
        child: Opacity(
          opacity: 1.0,
          child: Container(
            child: FlipInY(
              child: Container(
                child: Center(
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        width: double.infinity,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 30),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: CustomColors.white,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 25),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 10,),
                                    Center(
                                      child: Text(
                                        Strings.uploadPhoto,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: Strings.fontBold,
                                          color: CustomColors.blackLetter,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Container(height: 1, color: CustomColors.gray.withOpacity(.2),),
                                    SizedBox(height: 15),
                                    _btnCustom(Strings.btnGallery, null,
                                        "ic_gallery.png", () {
                                          statePermissionsPhotos = false;
                                          statePermissionsGallery = true;
                                          validateGallery();

                                    }),
                                    Divider(),
                                    _btnCustom(Strings.btnCamera, null,
                                        "ic_camera.png", () {
                                          statePermissionsPhotos = true;
                                          statePermissionsGallery = false;
                                          validateCamera();
                                    }),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 50,
                              child: Center(
                                child: Container(
                                    width: 51,
                                    height: 51,
                                    decoration: BoxDecoration(
                                        color: CustomColors.blueActiveDots,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100))),
                                    child: Center(
                                      child: GestureDetector(
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          child: Image(
                                              image: AssetImage(
                                                  "Assets/images/ic_close.png")),
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ))),
              ),
            ),
          ),
        ));
  }

  validateCamera() async {
    final status = await Permission.camera.request();
    validateStatusPermission(status);
  }

  validateGallery() async {

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        final status = await Permission.storage.request();
        validateStatusPermission(status);
        /// use [Permissions.storage.status]
      }  else {
        final status = await Permission.photos.request();
        validateStatusPermission(status);
        /// use [Permissions.photos.status]
      }
    }

  }

  Widget _btnCustom(
      String nameBottom, Color? color, String icon, Function action) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        child: Row(
          children: [
            Image.asset(
              "Assets/images/$icon",
              width: 35,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              nameBottom,
              style: TextStyle(
                  fontFamily: Strings.fontRegular,
                  fontSize: 15,
                  color: CustomColors.blackLetter),
            ),
          ],
        ),
      ),
      onTap: () {
        action();
      },
    );
  }

  validateStatusPermission(PermissionStatus status) async {
    switch (status) {
      case PermissionStatus.granted:
        if (statePermissionsPhotos) {
          _listener.openCamera();
        } else if (statePermissionsGallery) {
          _listener.openGallery();
        }
        break;
      case PermissionStatus.denied:
        //  bool aux = await showAlert(context, Strings.alertTextPhotos);
       /* if (true) {
          dismissDialog();
          statePermissionsPhotos = false;
        }*/
        if (true) {
          dismissDialog();
          openAppSettings();
        }
        /*AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.NO_HEADER,
            dialogBackgroundColor: Colors.transparent,
            body: DialogPermissionGallery(context, 'Permisos G')
        )..show();*/
        break;
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
      if (true) {
        dismissDialog();
        openAppSettings();
      }
      break;
      case PermissionStatus.limited:
        //bool aux = await showAlert(context, Strings.alertTextPhotos);
        if (true) {
          dismissDialog();
          openAppSettings();
        }
    }
  }
}
