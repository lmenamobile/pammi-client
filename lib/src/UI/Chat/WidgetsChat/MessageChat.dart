import 'package:flutter/material.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';

class MessageChat extends StatelessWidget {
  final String message, date, photo;
  final String uidUser;
  final int typeMessage;
  final bool isLocal;

  const MessageChat(
      {this.message,
      this.date,
      this.uidUser,
      this.typeMessage,
      this.photo,
      this.isLocal});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        hourMessage(date),
        Container(
          child: typeWidget(typeMessage, message, photo,isLocal),
        ),
      ],
    );
  }

  Widget typeWidget(int type, String message, String photo,bool isLocal) {
    switch (type) {
      case 1:
        return Container(
            margin: EdgeInsets.only(right: 10),
            child: messageLocal(message, photo));
        break;
      case 2:
        return Container(
            margin: EdgeInsets.only(left: 10),
            child: messageReceived(message, photo));
        break;
      case 3:
        return Container(
            margin: EdgeInsets.only(left: isLocal?0:10,right:isLocal?10:0),
            child: messageFile(message, photo, isLocal, 3));
        break;
      case 4:
        return Container(
            margin: EdgeInsets.only(left: isLocal?0:10,right:isLocal?10:0),
            child: messageFile(message, photo, isLocal, 4));
        break;
      default:
        return Container();
    }
  }
}

Widget messageLocal(String message, String photo) {
  return Align(
      alignment: Alignment.centerRight,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            margin: EdgeInsets.only(right: 10, bottom: 10, left: 50),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message,
                style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 15,
                    color: Colors.white),
              ),
            ),
            decoration: BoxDecoration(
                color: CustomColors.blue3,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )),
          ),
        ],
      ));
}

Widget messageReceived(String message, String photo) {
  return Align(
      alignment: Alignment.centerLeft,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            margin: EdgeInsets.only(right: 50, bottom: 10, left: 40),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message,
                style: TextStyle(
                    fontFamily: Strings.fontRegular,
                    fontSize: 15,
                    color: Colors.white),
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.black38.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )),
          ),
          Container(
              width: 30,
              height: 30,
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38.withOpacity(0.2),
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                      offset: Offset(
                        2.0,
                        2.0,
                      ),
                    )
                  ],
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: photo == ""
                          ? AssetImage("assets/images/ic_profile_default.png")
                          : NetworkImage(photo)))),
        ],
      ));
}

Widget messageFile(String data, String photo, bool isLocal, int type) {
  return Align(
      alignment: isLocal ? Alignment.centerRight : Alignment.centerLeft,
      child: Stack(
        alignment: isLocal ? Alignment.bottomRight : Alignment.topLeft,
        children: [
          type == 4
              ? Container(
                  margin: isLocal
                      ? EdgeInsets.only(right: 10, bottom: 10, left: 50)
                      : EdgeInsets.only(right: 50, bottom: 10, left: 40),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 15,
                          child: Icon(
                            Icons.description,
                            color: CustomColors.blue3,
                            size: 16,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          data,
                          style: TextStyle(
                              fontFamily: Strings.fontRegular,
                              fontSize: 15,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: CustomColors.blue3,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      )),
                )
              : Container(
                  margin: isLocal
                      ? EdgeInsets.only(right: 10, bottom: 10, left: 50)
                      : EdgeInsets.only(right: 50, bottom: 10, left: 40),
                  width: 170,
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: FadeInImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(data),
                        placeholder: AssetImage("Assets/images/spinner.gif"),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )),
                ),
          Visibility(
            visible: !isLocal,
            child: Container(
                width: 30,
                height: 30,
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38.withOpacity(0.2),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                        offset: Offset(
                          2.0,
                          2.0,
                        ),
                      )
                    ],
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: photo == ""
                            ? AssetImage("assets/images/ic_profile_default.png")
                            : NetworkImage(photo)))),
          ),
        ],
      ));
}

Widget hourMessage(String message) {
  return Align(
    alignment: Alignment.center,
    child: Container(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        message,
        style: TextStyle(
            fontFamily: Strings.fontRegular,
            fontSize: 12,
            color: CustomColors.gray7),
      ),
    )),
  );
}
