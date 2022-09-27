import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wawamko/src/Providers/ProviderChat.dart';
import 'package:wawamko/src/Providers/SocketService.dart';
import 'package:wawamko/src/UI/Chat/ChatPage.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';

class ContactPage extends StatelessWidget {
  ContactPage({Key? key}) : super(key: key);

  late ProviderChat providerChat;
  final SharePreference sharePreference = SharePreference();
  late SocketService socketService;

  @override
  Widget build(BuildContext context) {
    providerChat = Provider.of<ProviderChat>(context);
    socketService = Provider.of<SocketService>(context);
    return Scaffold(
      body: Container(
        color: CustomColors.whiteBackGround,
        width: double.infinity,
        child: SafeArea(child: _body(context)),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        //simpleHeader(context, _childHeader(context)),
        titleBar(Strings.contactUs, "ic_back.png",
                () => Navigator.pop(context)),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 5),
                    child: Text(
                      Strings.communicateOperator,
                      style: TextStyle(
                        color: CustomColors.black2,
                        fontFamily: Strings.fontMedium,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                //TODO: Add function
                ItemContact(
                  onTap: (){
                    utils.openWhatsapp(context: context, text: "Olis Jhonis", number: "3053217513");
                  },
                  title: Strings.whatsApp,
                  pathImage: "Assets/images/ic_whatsapp.svg",
                ),
                ItemContact(
                  onTap: (){openChat(context);},
                  title: Strings.pamiiChat,
                  pathImage: "Assets/images/ic_pamii.svg",
                ),
                ItemContact(
                  onTap: (){
                    utils.openUrl("https://web.telegram.org/z/");
                  },
                  title: Strings.telegram,
                  pathImage: "Assets/images/ic_telegram.svg",
                ),
                ItemContact(
                  onTap: (){
                    utils.openEmail("bel.jonas968@gmail.com", "this is the subject");
                  },
                  title: Strings.email2,
                  pathImage: "Assets/images/ic_email.svg",
                ),
                ItemContact(
                  onTap: (){
                    utils.openDial("3053217513");
                  },
                  title: Strings.call,
                  pathImage: "Assets/images/ic_call.svg",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  openChat(BuildContext context){
   getRoomSupport(context);
  }

  getRoomSupport(BuildContext context) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callChat = providerChat.getRomAdmin();
        await callChat.then((id) async {
          if(socketService.serverStatus!=ServerStatus.Online){
            socketService.connectSocket(Constants.typeAdmin, id,"");
          }
          Navigator.push(context, customPageTransition(ChatPage(roomId: id, typeChat: Constants.typeAdmin,imageProfile: Constants.profileAdmin,)));
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  Widget _childHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            Strings.contactUs,
            style: TextStyle(
              fontSize: 16,
              fontFamily: Strings.fontRegular,
              color: CustomColors.white,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: InkWell(
            child: Container(
              width: 45,
              height: 45,
              child: Image(
                image: AssetImage("Assets/images/ic_arrow.png"),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}

class ItemContact extends StatelessWidget {
  final String title;
  final String pathImage;
  final Function? onTap;

  const ItemContact(
      {Key? key, required this.title, required this.pathImage, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(

      onTap: () {
        onTap?.call();
      },
      child: Container(
        height: 65,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              child: SvgPicture.asset(pathImage),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 10),
              child: VerticalDivider(
                indent: 10,
                endIndent: 10,
                color: CustomColors.gray2,
                thickness: 1,
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: Strings.fontRegular,
                    color: CustomColors.blackLetter,
                  ),
                ),
              ),
            ),
            Container(
              child: Image(
                width: 30,
                height: 30,
                color: Colors.black.withOpacity(0.5),
                image: AssetImage("Assets/images/ic_arrow_black.png"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
