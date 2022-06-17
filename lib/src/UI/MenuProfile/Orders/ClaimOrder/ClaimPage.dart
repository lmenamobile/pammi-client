import 'package:flutter/material.dart';
import 'package:wawamko/src/UI/MenuProfile/Orders/ClaimOrder/WidgetsClaim.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';

class ClaimPage extends StatefulWidget {
  @override
  _ClaimPageState createState() => _ClaimPageState();
}

class _ClaimPageState extends State<ClaimPage> {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: CustomColors.whiteBackGround,
          child: Column(
            children: [
              titleBar(Strings.claim, "ic_back.png",
                  () => Navigator.pop(context)),

              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10
                    )
                  )
                ),
                child: Center(
                  child: Column(
                    mainAxisSize:MainAxisSize.min,
                    children: [
                      Text(
                        Strings.reasonClaim,
                        style: TextStyle(
                            color: CustomColors.blackLetter, fontFamily: Strings.fontMedium,fontSize: 16),
                      ),
                      Text(
                        Strings.selectReasonClaim,
                        style: TextStyle(
                            color: CustomColors.blue, fontFamily: Strings.fontMedium,fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: listReasonClaim())),
              Align(
                alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                    child: buttonNext(),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget listReasonClaim() {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 20),
        physics: NeverScrollableScrollPhysics(),
        itemCount:5,
        itemBuilder: (_, int index) {
          return itemReasonClaim();
        },
      ),
    );
  }
}
