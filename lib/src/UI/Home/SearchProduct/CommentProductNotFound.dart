import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/ProviderSettings.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/Validators.dart';
import 'package:wawamko/src/config/theme/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/LoadingProgress.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class CommentProductNotFound extends StatefulWidget {
  @override
  _CommentProductNotFoundState createState() => _CommentProductNotFoundState();
}

class _CommentProductNotFoundState extends State<CommentProductNotFound> {
  final emailController = TextEditingController();
  final commentController = TextEditingController();
  String msgError = '';
  late ProviderSettings providerSettings;

  @override
  Widget build(BuildContext context) {
    providerSettings = Provider.of<ProviderSettings>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                children: [

                  headerView( Strings.comment, () => Navigator.pop(context)),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              Strings.textCommentProduct,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: Strings.fontRegular,
                                  color: AppColors.gray8),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              height: 45,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(13)),
                                  border: Border.all(
                                      color: AppColors.blue, width: 1),
                                  color: AppColors.white),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        keyboardType: TextInputType.emailAddress,
                                        controller:emailController,
                                        inputFormatters: [ LengthLimitingTextInputFormatter(30)],
                                        style: TextStyle(
                                            fontFamily: Strings.fontRegular,
                                            color: AppColors.gray7),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                            color:
                                                AppColors.gray7.withOpacity(.4),
                                            fontFamily: Strings.fontRegular,
                                          ),
                                          hintText: Strings.email,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                              height: 130,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(13)),
                                  border: Border.all(
                                      color: AppColors.blue, width: 1),
                                  color: AppColors.white),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  maxLines: 5,
                                  maxLength: 200,
                                  inputFormatters: [ LengthLimitingTextInputFormatter(200)],
                                  textAlign: TextAlign.justify,
                                  controller: commentController,
                                  style: TextStyle(
                                      fontFamily: Strings.fontRegular,
                                      color: AppColors.gray7),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: AppColors.gray7.withOpacity(.4),
                                      fontFamily: Strings.fontRegular,
                                    ),
                                    hintText: Strings.informationProduct,
                                  ),
                                ),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          btnCustom(140, Strings.send, AppColors.blueSplash,
                              Colors.white, callSendComment),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                  visible: providerSettings.isLoading,
                  child: LoadingProgress()),
            ],
          ),
        ),
      ),
    );
  }

  callSendComment(){
    if(validateForm()){
      sendComment();
    }else{
      utils.showSnackBar(context, msgError);
    }
  }

  bool validateForm(){
    if (emailController.text.isEmpty) {
      msgError = Strings.emptyEmail;
      return false;
    } else if (!validateEmail(emailController.text.trim())) {
      msgError = Strings.emailInvalidate;
      return false;
    } else if (commentController.text.isEmpty) {
      msgError = Strings.commentEmpty;
      return false;
    }
    return true;
  }

  sendComment() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callProducts = providerSettings.sendCommentProductNoFound(emailController.text, commentController.text);
        await callProducts.then((msg) {
          Navigator.pop(context);
          utils.showSnackBarGood(context, msg.toString());
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }
}
