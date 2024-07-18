
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/ProviderChat.dart';
import 'package:wawamko/src/Providers/SocketService.dart';
import 'package:wawamko/src/UI/Chat/ChatPage.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/config/theme/colors.dart';
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
        color: Colors.white,
        width: double.infinity,
        child: SafeArea(child: _body(context)),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        //simpleHeader(context, _childHeader(context)),
        headerView(Strings.contactUs,  () => Navigator.pop(context)),
        const SizedBox(height: 40,),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 5),
                    child: Text(
                      Strings.communicateOperator,
                      style: TextStyle(
                        color: AppColors.black2,
                        fontFamily: Strings.fontMedium,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                ItemContact(
                  onTap: (){
                    utils.openWhatsapp(context: context, text: "Hola,como podemos ayudarte", number: "3103474819");
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
                    utils.openTelegram("3103474819", context);
                  },
                  title: Strings.telegram,
                  pathImage: "Assets/images/ic_telegram.svg",
                ),
                ItemContact(
                  onTap: (){
                    utils.openEmail("ayuda@estoespamii.com", "Hola,como podemos ayudarte");
                  },
                  title: Strings.email2,
                  pathImage: "Assets/images/ic_email.svg",
                ),
                ItemContact(
                  onTap: (){
                    utils.openDial("28104895000");
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
          Navigator.push(context, customPageTransition(ChatPage(roomId: id, typeChat: Constants.typeAdmin,imageProfile: Constants.profileAdmin,fromPush: false),PageTransitionType.rightToLeftWithFade));
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
              color: AppColors.white,
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
          color: AppColors.white,
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
                color: AppColors.gray2,
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
                    color: AppColors.blackLetter,
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
