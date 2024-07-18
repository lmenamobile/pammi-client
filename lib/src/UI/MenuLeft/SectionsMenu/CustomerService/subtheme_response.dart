import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/Themes/subtheme_response.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/config/theme/colors.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class SubThemeResponse extends StatefulWidget {
  final ItemQuestionsSubTheme itemQuestionsSubTheme;
  const SubThemeResponse({Key? key,required this.itemQuestionsSubTheme}) : super(key: key);

  @override
  _SubThemeResponseState createState() => _SubThemeResponseState();
}

class _SubThemeResponseState extends State<SubThemeResponse> {

  final RefreshController _refreshControllerQuestions = RefreshController();
  int offset = 0;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: _body(context))
    );
  }

  Widget _body(BuildContext context){
    return Column(
      children: [
        Container(
          width: double.infinity,
            color: Colors.transparent,
            child: Column(
          children: [
            headerView(Strings.frecuensQuestion, () => Navigator.pop(context)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),

              child: Text(
                widget.itemQuestionsSubTheme.question ?? "",
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: Strings.fontMedium,
                    color: AppColors.blackLetter
                ),
              ),
            )
          ],
        )),
        SizedBox(height: 10),
        Expanded(
          child:  SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
                    child:Html(
                      data :widget.itemQuestionsSubTheme.response,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ],
    );
  }





}
