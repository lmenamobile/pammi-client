import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/pqrs_provider.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/CustomerService/pqrs/listTypeSupport.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class CreatePqrs extends StatefulWidget {
  const CreatePqrs({Key? key}) : super(key: key);

  @override
  _CreatePqrsState createState() => _CreatePqrsState();
}

class _CreatePqrsState extends State<CreatePqrs> {

  final TextEditingController _typeSupportController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  late PQRSProvider pqrsProvider;

  int lengthValue = 0;

  @override
  Widget build(BuildContext context) {
    pqrsProvider = Provider.of<PQRSProvider>(context);
    return Scaffold(
      body: SafeArea(child: _body(context)),
    );
  }

  Widget _body(BuildContext context){
    return Stack(
      children: [
        Visibility(
            visible: pqrsProvider.isLoadingPqrs,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            )),
        Column(
          children: [
            headerView( Strings.pqrs, () => Navigator.pop(context)),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${Strings.create} ${Strings.pqrs}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: Strings.fontBold,
                          color: CustomColorsAPP.blackLetter,
                          fontSize: 18
                      ),
                    ),
                    SizedBox(height: 20),
                    selectSupportType(_typeSupportController),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: (){
                        pqrsProvider.isRevealIdentity = !pqrsProvider.isRevealIdentity;
                      },
                      child: Container(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Image(
                              image: pqrsProvider.isRevealIdentity ? AssetImage("Assets/images/btn_selected.png") : AssetImage("Assets/images/btn_unselected.png") ,
                              width: 20,
                              height: 20,

                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                Strings.notRevealIdentity,
                                style: TextStyle(
                                  fontFamily: Strings.fontRegular,
                                  fontSize: 16,
                                  color: CustomColorsAPP.blackLetter
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 19,vertical: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          border: Border.all(color: CustomColorsAPP.gray.withOpacity(.6),width: 1)
                      ),child: TextField(
                      controller: _topicController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          enabled: true,
                          hintStyle: TextStyle(
                              fontSize: 15,
                              color: CustomColorsAPP.gray,
                              fontFamily: Strings.fontRegular
                          ),
                          hintText: Strings.topic
                      ),
                      style: TextStyle(
                          fontSize: 15,
                          color: CustomColorsAPP.blackLetter,
                          fontFamily: Strings.fontRegular
                      ),
                      cursorColor: CustomColorsAPP.blackLetter,

                    ),
                    ),
                    SizedBox(height: 20),
                    textFieldAreaCustom(_messageController, Strings.message,_countChartsMessage),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Text(
                          "(${this.lengthValue}/500)",
                          style: TextStyle(
                            fontFamily: Strings.fontRegular,
                            color: CustomColorsAPP.grayOne,
                            fontSize: 13
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 24),
                    btnCustom(double.infinity, Strings.create, CustomColorsAPP.blueSplash, Colors.white, _createPQRS),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),


          ],
        ),

      ],
    );
  }

  _countChartsMessage(String value){
    this.lengthValue = value.length;
    setState(() {

    });
  }

  _createPQRS(){
    if(_validateFields()){
      createPQRS();
    }
  }

  bool _validateFields(){
    if(_typeSupportController.text.trim() == ""){
      utils.showSnackBarError(context, Strings.inputTypeSupport);
      return false;
    }else if(_topicController.text.trim() == ""){
      utils.showSnackBarError(context, Strings.inputTopic);
      return false;
    }else if(_messageController.text.trim() == ""){
      utils.showSnackBarError(context, Strings.inputMessage);
      return false;
    }

    return true;
  }

  Widget selectSupportType(TextEditingController controller){
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child:ListTypeSupportPage(),
            duration: Duration(milliseconds: 700),
          ),
        ).then((value) {
          if(value == "update"){
            print("update");
            _typeSupportController.text = pqrsProvider.typeSupportSelected.typeSupport ?? "";
          }
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 19,vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          border: Border.all(color: CustomColorsAPP.gray.withOpacity(.6),width: 1)
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabled: false,
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: CustomColorsAPP.gray,
                    fontFamily: Strings.fontRegular
                  ),
                  hintText: Strings.supportType
                ),
                style: TextStyle(
                    fontSize: 15,
                    color: CustomColorsAPP.blackLetter,
                    fontFamily: Strings.fontRegular
                ),
                cursorColor: CustomColorsAPP.blackLetter,

              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: CustomColorsAPP.gray,
              size: 20,
            )
          ],
        ),
      ),
    );
  }

  _returnToListPqrs(){
    Navigator.pop(context);
    Navigator.pop(context,"update");
  }

  createPQRS() {
    utils.check().then((value) async {
      if (value) {
        Future<dynamic> pqrsFuture =
        pqrsProvider.createPQRS(pqrsProvider.typeSupportSelected.sendTypeSupport ?? "", _topicController.text.trim(),_messageController.text.trim(), pqrsProvider.isRevealIdentity);
        await pqrsFuture.then((value) {
          if(value != null){
            if(value == "OK"){
              utils.showDialogCreatePqrs(context, pqrsProvider.dataCreatePqrs.savedPqrs!.id.toString(),_returnToListPqrs);
            }else{
              utils.showSnackBarError(context, value);
            }
          }
        });
      } else {
        pqrsProvider.listPqrs = [];
        utils.showSnackBarError(context, Strings.internetError);
      }
    });
  }

}
