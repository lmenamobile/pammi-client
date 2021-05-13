import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wawamko/src/Models/Support/QuestionsModel.dart';
import 'package:wawamko/src/Models/Support/TermsConditionsModel.dart';
import 'package:wawamko/src/Providers/SupportProvider.dart';
import 'package:wawamko/src/UI/InterestCategoriesUser.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/drawerMenu.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class SupportHelpPage extends StatefulWidget {
  @override
  _SupportHelpPageState createState() => _SupportHelpPageState();
}

class _SupportHelpPageState extends State<SupportHelpPage> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  List<Question> questions = List();
  List<Term> terms = List();
  //bool loading = true;

  @override
  void initState() {
    serviceGetQuestions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: DraweMenuPage(rollOverActive: "support",),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context){
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            height: 9,
            color: CustomColors.blueSplash,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(top: 10),
            width: double.infinity,
            height: 90,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("Assets/images/ic_header.png"),
                    fit: BoxFit.fitWidth
                )
            ),
            child:  Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    height: 9,
                    color: CustomColors.blueSplash,
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 15,
                  child: GestureDetector(
                    child: Container(
                      width: 40,
                      height: 40,
                      child: Image(
                        image: AssetImage("Assets/images/ic_menu_w.png"),
                      ),
                    ),
                    onTap: (){
                      //FocusScope.of(context).unfocus();
                     _drawerKey.currentState.openDrawer();
                      //singleton.eventRefreshCheckout.broadcast();
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 25),
                  child: Text(
                    Strings.supportAndService,
                    style: TextStyle(
                        fontFamily: Strings.fontArial,
                        fontSize: 17,
                        color: CustomColors.white

                    ),
                  ),
                )
              ],
            ),
          ),

        ),
        Positioned(
          top: 90,
          left: 0,
          right: 0,
          bottom: 0,
          child: SingleChildScrollView(
            child: Column(
                children: <Widget>[

                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(left: 70,right: 70),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          width: 135,
                          height: 135,
                          image: AssetImage("Assets/images/ic_customer.png"),
                        ),
                        SizedBox(height: 10),
                        Text(
                          Strings.support,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: Strings.fontArialBold,
                              color: CustomColors.blackLetter
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(

                          Strings.supportMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: Strings.fontArial,
                              color: CustomColors.blueGray
                          ),
                        ),


                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20,right: 20),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Column(


                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(top: 0),
                                child: ListView.builder(
                                  itemCount: this.questions.length ?? 0,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index){

                                      return itemHelpCenter(this.questions[index].question, (){
                                      });
                                    }
                                ),
                              ),

                              Container(
                                width: double.infinity,
                                child: ListView.builder(
                                    padding: EdgeInsets.only(top: 0),
                                    itemCount: this.terms.length ?? 0,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (BuildContext context, int index){

                                      return itemHelpCenter(this.terms[index].name, (){launch(this.terms[index].url);
                                      });
                                    }
                                ),
                              ),


                            ],
                          )

                      ),
                    ),




                ]
            ),
          ),
        )
      ],

    );
  }

  serviceGetQuestions() async {
    this.questions = [];
    utils.checkInternet().then((value) async {
      if (value) {
        utils.startProgress(context);


        // Navigator.of(context).push(PageRouteBuilder(opaque: false, pageBuilder: (BuildContext context, _, __) => DialogLoadingAnimated()));
        Future callResponse = SupportProvider.instance.getQuestions(context);
        await callResponse.then((user) {
          var decodeJSON = jsonDecode(user);
          QuestionsResponse data = QuestionsResponse.fromJson(decodeJSON);

          if(data.status) {


            for(var question in data.data.questions ){
              this.questions.add(question);
            }

            serviceGetTerms();
          }else{
            Navigator.pop(context);
            setState(() {

            });
            // utils.showSnackBarError(context,data.message);
          }

          //loading = false;
        }, onError: (error) {
          print("Ocurrio un error: ${error}");
          //loading = false;
          Navigator.pop(context);
        });
      }else{
       // loading = false;
        utils.showSnackBarError(context,Strings.loseInternet);
      }
    });
  }

  serviceGetTerms() async {
    this.terms = [];
    utils.checkInternet().then((value) async {
      if (value) {



        // Navigator.of(context).push(PageRouteBuilder(opaque: false, pageBuilder: (BuildContext context, _, __) => DialogLoadingAnimated()));
        Future callResponse = SupportProvider.instance.getTermsAndConditions(context);
        await callResponse.then((user) {
          var decodeJSON = jsonDecode(user);
          TermsConditionsResponse data = TermsConditionsResponse.fromJson(decodeJSON);

          if(data.status) {


            for(var term in data.data.terms ){
              this.terms.add(term);
              // this.questions.add(question);
            }
            Navigator.pop(context);
            setState(() {

            });

          }else{
            Navigator.pop(context);
            setState(() {

            });
            // utils.showSnackBarError(context,data.message);
          }

          //loading = false;
        }, onError: (error) {
          print("Ocurrio un error: ${error}");
          //loading = false;
          Navigator.pop(context);
        });
      }else{
        // loading = false;
        utils.showSnackBarError(context,Strings.loseInternet);
      }
    });
  }

}
