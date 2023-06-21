import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Models/Order/MethodDevolution.dart';
import 'package:wawamko/src/Models/Claim/TypeClaim.dart';
import 'package:wawamko/src/Models/Claim/TypeReason.dart';
import 'package:wawamko/src/Providers/ProviderClaimOrder.dart';
import 'package:wawamko/src/UI/Home/HomePage.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/ClaimOrder/MyClaimPage.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/ClaimOrder/WidgetsClaim.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Utils/utilsPhoto/image_picker_handler.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class ClaimPage extends StatefulWidget {
  final String idPackage;

  const ClaimPage({required this.idPackage});
  @override
  _ClaimPageState createState() => _ClaimPageState();
}

class _ClaimPageState extends State<ClaimPage> with TickerProviderStateMixin, ImagePickerListener {
  late ProviderClaimOrder providerClaimOrder;
  final commentController = TextEditingController();
  AnimationController? _controller;
  late ImagePickerHandler imagePicker;

  @override
  void initState() {
    providerClaimOrder = Provider.of<ProviderClaimOrder>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      providerClaimOrder.setValueStep = 1;
      providerClaimOrder.setImageFile = File('');
      providerClaimOrder.selectTypeReason = null;
      providerClaimOrder.selectTypeClaim = null;
      providerClaimOrder.selectMethodDevolution = null;


    });
    _controller = new AnimationController(vsync: this, duration: const Duration(milliseconds: 500),);
    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    providerClaimOrder = Provider.of<ProviderClaimOrder>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                children: [

               header(context, Strings.claim, CustomColors.redDot, () =>stepsBtnBack()),
               stepsFormsRequestClaim(providerClaimOrder.valueStep),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        child: InkWell(
                          onTap: ()=>stepsBtnNext(),
                            child: buttonNext()),
                      ))
                ],
              ),
              Visibility(
                  visible: providerClaimOrder.isLoading, child: LoadingProgress())
            ],
          ),
        ),
      ),
    );
  }

  Widget stepsFormsRequestClaim(int position) {
    switch (position) {
      case 1:
        return stepOneReasonClaim();
      case 2:
        return stepTwoTypeClaim();
      case 3:
        return stepThreeSupportClaim();
      case 4:
        return stepFourMethodDevolution();
      default:
        return Container();
    }
  }

   stepsBtnNext() {
    switch (providerClaimOrder.valueStep) {
      case 1:
        return {
          providerClaimOrder.typeReasonSelected!=null?providerClaimOrder.setValueStep = 2: utils.showSnackBar(context, Strings.errorSelectTypeReason)
        };
      case 2:
        return {
         providerClaimOrder.typeClaimSelected!=null? providerClaimOrder.setValueStep = 3: utils.showSnackBar(context, Strings.errorSelectTypeClaim)
        };
      case 3:
        return {
          commentController.text.isNotEmpty? providerClaimOrder.setValueStep = 4: utils.showSnackBar(context, Strings.errorCommentClaim)
        };
      case 4:
        return {
          providerClaimOrder.methodDevolution!=null?
              createClaim(widget.idPackage,commentController.text): utils.showSnackBar(context, Strings.errorMethodReturnClaim)
        };
      default:
        return Container();
    }
  }

  stepsBtnBack() {
    switch (providerClaimOrder.valueStep) {
      case 1:
        return  {
          providerClaimOrder.clearValues(),
          Navigator.pop(context)
        };
      case 2:
        return providerClaimOrder.setValueStep = 1;
      case 3:
        return providerClaimOrder.setValueStep = 2;
      case 4:
        return providerClaimOrder.setValueStep = 3;
      default:
        return Container();
    }
  }

  Widget stepOneReasonClaim() {
    return Expanded(
        child: SingleChildScrollView(
        child:Column(
        children: [
          headerClaim(
            Strings.reasonClaim,
            Strings.selectReasonClaim,
          ),
          listReasonClaim(),
        ],
      ),
        )
    );
  }

  Widget stepTwoTypeClaim() {
    return Expanded(
        child: SingleChildScrollView(
        child: Column(
        children: [
          headerClaim(
            Strings.typeClaim,
            Strings.selectTypeClaim,
          ),
         listTypeClaim()
        ],
      ),
        )
    );
  }

  Widget stepThreeSupportClaim(){
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            headerClaim(
              Strings.messageClaim,
              Strings.messageInformationClaim,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              width: double.infinity,
              height: 145,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: CustomColors.grayOne),
                  borderRadius: BorderRadius.circular(10),
                 ),
              child: Padding(
                padding:
                const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: TextField(
                  textInputAction: TextInputAction.done,
                  controller: commentController,
                  maxLines: 5,
                  maxLength: 250,
                  textAlign: TextAlign.justify,
                  inputFormatters: [],
                  style: TextStyle(
                      fontFamily: Strings.fontRegular,
                      color: CustomColors.gray7),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: Strings.hintComment,
                    hintStyle: TextStyle(
                        fontFamily: Strings.fontRegular,
                        color: CustomColors.gray5),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 25),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(color: CustomColors.blue)
                  ),
                    child: Center(child: providerClaimOrder.imageFile?.path==""?Image.asset("Assets/images/ic_add_file.png",width: 50,):
                    Image.file(providerClaimOrder.imageFile!,width: 100,height: 100,fit: BoxFit.fill,))),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          Strings.optional,
                          style: TextStyle(
                              fontFamily: Strings.fontMedium, color: CustomColors.gray7),
                        ),
                        Text(
                          Strings.messageLoadFile,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontFamily: Strings.fontRegular, color: CustomColors.gray7),
                        ),
                        SizedBox(height: 20,),
                        providerClaimOrder.imageFile?.path==""?InkWell(
                          onTap: ()=>imagePicker.showDialog(context),
                          child: Text(
                            Strings.loadFile,
                            style: TextStyle(
                                fontFamily: Strings.fontMedium, color: CustomColors.blue),
                          ),
                        ):Container(
                            decoration: BoxDecoration(
                              color: CustomColors.red,
                              borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                            child: IconButton(onPressed: ()=>providerClaimOrder.setImageFile = File(''), icon: Icon(Icons.delete,color: Colors.white,))),
                      ],
                    ),
                  ),
                )
              ],),
            )
          ],
        ),
      ),
    );
  }

  Widget stepFourMethodDevolution() {
    return Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              headerClaim(
                Strings.devolutionClaim,
                Strings.selectDevolutionClaim,
              ),
              listMethodDevolution()
            ],
          ),
        )
    );
  }

  Widget listReasonClaim() {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 20),
        physics: NeverScrollableScrollPhysics(),
        itemCount: utils.getLtsTypeReason.length,
        itemBuilder: (_, int index) {
          return InkWell(
              onTap: () => selectReasonClaim(
                  utils.getLtsTypeReason.elementAt(index)),
              child: itemReasonClaim(
                  utils.getLtsTypeReason.elementAt(index).typeReason ?? '',
                  providerClaimOrder.typeReasonSelected?.typeReason ?? ''));
        },
      ),
    );
  }

  Widget listTypeClaim() {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 20),
        physics: NeverScrollableScrollPhysics(),
        itemCount: utils.getLtsTypeClaim.length,
        itemBuilder: (_, int index) {
          return InkWell(
              onTap: () => selectTypeClaim(
                  utils.getLtsTypeClaim.elementAt(index)),
              child: itemReasonClaim(
                  utils.getLtsTypeClaim.elementAt(index).typeClaim ?? '',
                  providerClaimOrder.typeClaimSelected?.typeClaim?? ''));
        },
      ),
    );
  }

  Widget listMethodDevolution() {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 20),
        physics: NeverScrollableScrollPhysics(),
        itemCount: utils.getLtsMethodDevolution.length,
        itemBuilder: (_, int index) {
          return InkWell(
            onTap: ()=>selectMethodDevolution(utils.getLtsMethodDevolution.elementAt(index)),
              child: itemReasonClaim(
                  utils.getLtsMethodDevolution.elementAt(index).methodDevolution ?? '',
                 providerClaimOrder.methodDevolution?.methodDevolution??''));
        },
      ),
    );
  }

  selectReasonClaim(TypeReason typeReason) {
    providerClaimOrder.selectTypeReason = typeReason;
  }

  selectTypeClaim(TypeClaim typeClaim) {
    providerClaimOrder.selectTypeClaim= typeClaim;
  }

  selectMethodDevolution(MethodDevolution method) {
    providerClaimOrder.selectMethodDevolution = method;
  }

  nextStep(){
    providerClaimOrder.setValueStep = 3;
  }

  createClaim(String idPackage,String message) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callClaim = providerClaimOrder.createClaim(
        providerClaimOrder.typeReasonSelected!,
            providerClaimOrder.typeClaimSelected!,
            providerClaimOrder.imageFile??File(''),
            providerClaimOrder.methodDevolution!, idPackage, message);
        await callClaim.then((list) async{
          var state = await startAlertCustomImage(context,Strings.claimCreate,Strings.claimTextInfo,"ic_correct.png");
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyHomePage()), (Route<dynamic> route) => false);
          Navigator.push(context, customPageTransition(MyClaimPage()));
        }, onError: (error) {
           utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  @override
  userImage(File? _image){
    if (_image != null) {
      providerClaimOrder.setImageFile = _image;
      print(_image.lengthSync()/1000);
    } else {
      utils.showSnackBar(context, Strings.errorPhoto);
    }
  }

}
