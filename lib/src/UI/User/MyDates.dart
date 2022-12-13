import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/UI/SearchCountryAndCity/SelectStates.dart';
import 'package:wawamko/src/Utils/FunctionsUtils.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Bloc/notifyVaribles.dart';
import 'package:wawamko/src/Utils/GlobalVariables.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utilsPhoto/image_picker_handler.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';
import 'package:wawamko/src/Widgets/dialogAlertSelectDocument.dart';
import 'package:wawamko/src/UI/SearchCountryAndCity/selectCountry.dart';
import 'package:wawamko/src/UI/changePassword.dart';
import 'package:flutter/services.dart';
import 'package:wawamko/src/Providers/ProfileProvider.dart';
import 'package:wawamko/src/Utils/utils.dart';

class MyDatesPage extends StatefulWidget {
  @override
  _MyDatesPageState createState() => _MyDatesPageState();
}

class _MyDatesPageState extends State<MyDatesPage>
    with TickerProviderStateMixin, ImagePickerListener {
  SharePreference prefs = SharePreference();
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final typeDocumentController = TextEditingController();
  final numberIdentityController = TextEditingController();
  final emailController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();
  var maskFormatter = new MaskTextInputFormatter(
      mask: '###############', filter: {"#": RegExp(r'[0-9]')});
  AnimationController? _controller;
  late ImagePickerHandler imagePicker;
  NotifyVariablesBloc? notifyVariables;
  String msgError = '';
  GlobalVariables globalVariables = GlobalVariables();
  ProfileProvider? profileProvider;
  ProviderSettings? providerSettings;

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    notifyVariables = Provider.of<NotifyVariablesBloc>(context);
    providerSettings = Provider.of<ProviderSettings>(context);
    profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: CustomColors.redTour,
              child: _body(context),
            ),
            Visibility(
                visible: profileProvider!.isLoading, child: LoadingProgress()),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Stack(
      children: [
        Image.asset("Assets/images/ic_bg_profile.png"),
        Column(
          children: <Widget>[
            Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            width: 31,
                            height: 31,
                            child: Center(
                              child: Image(
                                image: AssetImage(
                                    "Assets/images/ic_backward_arrow.png"),
                              ),
                            ),
                          ),
                          onTap: (){Navigator.pop(context);
                          profileProvider!.imageUserFile = null;
                          profileProvider!.isEditProfile = false;},
                        ),
                        Expanded(
                            child: Center(
                          child: Text(
                            Strings.myDates,
                            style: TextStyle(
                                fontFamily: Strings.fontBold,
                                fontSize: 15,
                                color: CustomColors.white),
                          ),
                        )),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    child: Column(
                      children: [
                        Row(
                          children: <Widget>[
                            Container(
                              height: 65,
                              width: 65,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                border: Border.all(
                                    color: CustomColors.white, width: 1),
                              ),
                              child: Center(
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      height: 55,
                                      width: 55,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                        border: Border.all(
                                            color: CustomColors.white,
                                            width: 1),
                                        color: CustomColors.grayBackground,
                                      ),
                                      child: InkWell(
                                        onTap: () =>
                                            imagePicker.showDialog(context),
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100)),
                                            child: profileProvider!.imageUserFile==null?FadeInImage(
                                              image: profileProvider?.user != null ? NetworkImage(profileProvider?.user?.photoUrl??'') : NetworkImage(prefs.photoUser)
                                              ,
                                              fit: BoxFit.cover,
                                              placeholder: AssetImage(
                                                  "Assets/images/ic_img_profile.png"),
                                              imageErrorBuilder: (_,__,___){
                                                return Container();
                                              },
                                            ):Image.file(profileProvider!.imageUserFile!),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 23),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                InkWell(
                                  onTap: () => imagePicker.showDialog(context),
                                  child: Text(
                                    Strings.changePhoto,
                                    style: TextStyle(
                                        fontFamily: Strings.fontRegular,
                                        color: CustomColors.white,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Visibility(
                                  visible: profileProvider!.isEditProfile,
                                  child: Container(
                                      width: 130,
                                      child: btnRoundedCustom(
                                          30,
                                          CustomColors.yellowOne,
                                          CustomColors.blackLetter,
                                          Strings.saveDates, () {
                                        callServiceUpdate();
                                      })),
                                ),
                                Visibility(
                                  visible: !profileProvider!.isEditProfile,
                                  child: Container(
                                      width: 100,
                                      child: btnRoundedCustom(
                                          30,
                                          CustomColors.white,
                                          CustomColors.gray7,
                                          Strings.edit, () {
                                        profileProvider!.isEditProfile = true;
                                      })),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: CustomColors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Strings.personalInfo,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: CustomColors.blackLetter,
                                      fontFamily: Strings.fontBold),
                                ),
                                SizedBox(height: 20),
                                customTextFieldIcon("ic_data.png",true, Strings.nameUser,
                                    nameController, TextInputType.text, [ LengthLimitingTextInputFormatter(30)]),
                                InkWell(
                                    onTap: ()=>pushToSelectDocument(),
                                    child: customTextFieldIcon("ic_identity.png",false, Strings.typeDocument,typeDocumentController, TextInputType.text, [])),
                                customTextFieldIcon("ic_identity.png",true, Strings.idNumberDocument,
                                    numberIdentityController, TextInputType.text, [ LengthLimitingTextInputFormatter(30),FilteringTextInputFormatter.digitsOnly]),
                                InkWell(
                                    onTap: ()=>openSelectCountry(),
                                    child: customTextFieldIcon("ic_country.png",false, Strings.country, countryController, TextInputType.text, [])),
                                InkWell(
                                    onTap: ()=>openSelectCityByState(),
                                    child: customTextFieldIcon("ic_country.png",false, Strings.city, cityController, TextInputType.text, [])),
                                customTextFieldIcon("ic_telephone.png", true, Strings.phoneNumber,
                                    phoneController, TextInputType.number, [LengthLimitingTextInputFormatter(15),FilteringTextInputFormatter.digitsOnly]),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            top: 0,
                            child: Visibility(
                                visible: !profileProvider!.isEditProfile,
                                child: Container(
                                  color: Colors.transparent,
                                  width: double.infinity,
                                )),
                          )
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 30),
                          child: btnCustomRounded(CustomColors.blueSplash,
                              CustomColors.white, Strings.changePass, () {
                            Navigator.of(context).push(
                                customPageTransition(ChangePasswordPage()));
                          }, context))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  openSelectCountry()async{
     await Navigator.push(context, customPageTransition(SelectCountryPage()));
    countryController.text = providerSettings?.countrySelected?.country??'';
  }

  openSelectCityByState()async{
    if(providerSettings?.countrySelected!=null) {
      await Navigator.push(context, customPageTransition(SelectStatesPage()));
      cityController.text = providerSettings?.citySelected?.name??'';
    }else{
      utils.showSnackBar(context, Strings.countryEmpty);
    }
  }

  void setDataProfile() {
    nameController.text = profileProvider?.user?.fullname??'';
    typeDocumentController.text = profileProvider?.user?.documentType??'';
    numberIdentityController.text = profileProvider?.user?.document??'';
    countryController.text = profileProvider?.user?.city?.countryUser?.country??'';
    cityController.text = profileProvider?.user?.city?.name??'';
    phoneController.text = profileProvider?.user?.phone??'';
    globalVariables.cityId = profileProvider?.user?.city?.id;
    prefs.photoUser = profileProvider?.user?.photoUrl??'';
  }

  bool validateFormProfile() {
    bool validateForm = true;
    msgError = '';
    if (phoneController.text.isNotEmpty) {
      if (phoneController.text.length <= 7) {
        validateForm = false;
        msgError = Strings.phoneInvalidate;
      }
    }
    if (nameController.text.isEmpty) {
      validateForm = false;
      msgError = Strings.nameEmpty;
    }
    if (typeDocumentController.text.isEmpty) {
      validateForm = false;
      msgError = Strings.documentTypeEmpty;
    }
    if (numberIdentityController.text.isEmpty) {
      validateForm = false;
      msgError = Strings.numberEmpty;
    }
    if (countryController.text.isEmpty) {
      validateForm = false;
      msgError = Strings.cityEmpty;
    }
    return validateForm;
  }

  pushToSelectDocument() async {
    var data = await Navigator.of(context).push(PageRouteBuilder(
        opaque: false, // set to false
        pageBuilder: (_, __, ___) => DialogSelectDocument()));
    if (data != null) {
      if (data) {
        FocusScope.of(context).unfocus();
        typeDocumentController.text = globalVariables.typeDocument.toString();
      }
    }
  }

  callServiceUpdate() {
    if (validateFormProfile()) {
      serviceUpdateUser();
    } else {
      utils.showSnackBar(context, msgError);
    }
  }

  serviceUpdateUser() async {
    FocusScope.of(context).unfocus();
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = profileProvider!.updateUser(
            nameController.text,
            getTypeDocument(typeDocumentController.text),
            numberIdentityController.text,
            phoneController.text,
            providerSettings!.citySelected ==null?globalVariables.cityId.toString() :providerSettings!.citySelected!.id.toString());
        await callUser.then((msg) {
          profileProvider!.isEditProfile = false;
          //getUser();
          serviceUpdatePhoto(profileProvider!.imageUserFile!);
          utils.showSnackBarGood(context, msg.toString());
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

  serviceUpdatePhoto(File picture) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = profileProvider!.serviceUpdatePhoto(picture);
        await callUser.then((msg) {
          getUser();
          utils.showSnackBarGood(context, msg.toString());
        }, onError: (error) {
          getUser();
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

  getUser() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = profileProvider!.getDataUser();
        await callUser.then((msg) {
          setDataProfile();
        }, onError: (error) {
          profileProvider!.isLoading = false;
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

  @override
  userImage(File? imageFile) {
    if (imageFile != null) {
      profileProvider!.imageUserFile = imageFile;

    } else {
      utils.showSnackBar(context, Strings.errorPhoto);
    }
  }
}
