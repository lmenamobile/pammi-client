import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/ProviderChat.dart';
import 'package:wawamko/src/Providers/SocketService.dart';
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'package:wawamko/src/Widgets/widgets.dart';
import 'WidgetsChat/MessageChat.dart';

class ChatPage extends StatefulWidget {
  final String? roomId,orderId,subOrderId,typeChat,imageProfile;
  final bool fromPush;

  const ChatPage({required this.roomId, this.orderId, this.subOrderId,required this.typeChat,required this.imageProfile, required this.fromPush});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ProviderChat providerChat;
  late SocketService socketService;
  final prefs = SharePreference();
  final messageController = TextEditingController();
  final focusMessage = FocusNode();


  @override
  void initState() {
    super.initState();
    socketService = Provider.of<SocketService>(context,listen: false);
    providerChat = Provider.of<ProviderChat>(context,listen: false);
    providerChat.ltsMessages.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(widget.fromPush){
        getRoomIdAndMessagesFromPush();
      }else{
        providerChat.setMessagesListAdmin(widget.imageProfile??'');
      }

    });
    messageReceiveType(widget.typeChat);
  }


  @override
  Widget build(BuildContext context) {
    socketService = Provider.of<SocketService>(context);
    providerChat = Provider.of<ProviderChat>(context);
    return Scaffold(
      backgroundColor: CustomColorsAPP.redTour,
      body: SafeArea(
        child: Container(
          color: CustomColorsAPP.whiteBackGround,
          child: Column(
            children: [

              headerView(Strings.chat, (){this.socketService.disconnectSocket();
              Navigator.pop(context);}),
              SizedBox(height: 20,),
              Expanded(
                  child:ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: providerChat.ltsMessages.length,
                    reverse: true,
                    itemBuilder: (_,i)=>providerChat.ltsMessages[i],
                  )
              ),
              Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))
                ),
                child: Row(
                  children: [
                    SizedBox(width: 8,),
                    IconButton(icon: Image.asset("Assets/images/icon_attachment.png",width: 25), onPressed: ()=>_handleAttachmentPressed()),
                    Flexible(
                      child: Container(
                        child: Container(
                          margin: EdgeInsets.all(8),
                          child: TextField(
                            style: TextStyle(
                                fontFamily: Strings.fontRegular,
                                color: Colors.white),
                            controller:messageController,
                            onSubmitted: handleSummit,
                            onChanged: (String text){

                            },
                            decoration: InputDecoration.collapsed(
                                hintText:Strings.sendMessage,
                              hintStyle: TextStyle(
                                  fontFamily: Strings.fontRegular,
                                  color: Colors.white
                              )
                            ),
                            focusNode: focusMessage,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: InkWell(
                        onTap: (){
                          handleSummit(messageController.text.trim());
                        },
                        child:Image.asset("Assets/images/icon_send.png",width: 25),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getRoomIdAndMessagesFromPush(){

  }

  handleSummit(String text){
    if(text.isNotEmpty) {
      messageController.clear();
      focusMessage.requestFocus();
      final message = MessageChat(uidUser: '1', message: text.toString().trim(),date: formatDate( DateTime.now(),'yyyy-MM-dd h:mm a',"es_CO"), typeMessage: 1,photo:'',);
      providerChat.addMessages = message;
      this.socketService.emit(typeEmit(widget.typeChat), { json.encode({
      'room':widget.roomId,
      'type':"text",
      'typeUser':"user",
      'message':text.toString().trim()
      })}
      );
    }
  }

  messageReceive(dynamic data){
    print(data);
    switch (data["type"]) {
      case "text":
        final message = MessageChat(uidUser: '1', message:data['message'],date: formatDate( DateTime.now(),'yyyy-MM-dd h:mm a',"es_CO"), typeMessage: 2,photo: data['image'],isLocal: false,);
        providerChat.addMessages = message;
        break;
      case "image":
        var dataMessage = json.decode(data['message']);
        final message = MessageChat(uidUser: '1', message:dataMessage['url'],date: formatDate( DateTime.now(),'yyyy-MM-dd h:mm a',"es_CO"), typeMessage: 3,photo: data['image'],isLocal: false,urlFile: dataMessage['url'],);
        providerChat.addMessages = message;
        break;
      case "file":
        var dataMessage = json.decode(data['message']);
        final message = MessageChat(uidUser: '1', message:dataMessage['name'],date: formatDate( DateTime.now(),'yyyy-MM-dd h:mm a',"es_CO"), typeMessage: 4,photo: data['image'],isLocal: false,urlFile: dataMessage['url'],);
        providerChat.addMessages = message;
        break;

    }
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc','docx'],
    );
    if (result != null) {
      File file = File(result.files.single.path ?? "");

      serviceUpdatePhoto(file,result.files.single.name,4, result.files.single.size.toString());
    }
  }

  void _handleImageSelection() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );
    if (result != null) {
      File file = File(result.files.single.path ?? "");
      serviceUpdatePhoto(file,"",3,result.files.single.size.toString());
    }
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: 144,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                btnSheet("Imagen", (){
                  Navigator.pop(context);
                  _handleImageSelection();
                }),
                btnSheet("Archivo", (){
                  Navigator.pop(context);
                  _handleFileSelection();
                }),
                btnSheet("Cancelar", ()=>Navigator.pop(context)),
              ],
            ),
          ),
        );
      },
    );
  }

  serviceUpdatePhoto(File file,String name,int type,String size) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerChat.serviceSendFile(file);
        await callUser.then((msg) {
          if(type==3) {
            this.socketService.emit(typeEmit(widget.typeChat), {
              json.encode({
                'room': widget.roomId,
                'type': "image",
                'typeUser': "user",
                'message': json.encode(
                    {'name': widget.roomId, 'url': msg, "size": size})
              })}
            );
          }else{
            this.socketService.emit(typeEmit(widget.typeChat), {      json.encode({
              'room': widget.roomId,
              'type': "file",
              'typeUser': "user",
              'message': json.encode(
                  {'name': name, 'url': msg, "size": size})
            })}

            );
          }
          final message = MessageChat(uidUser: '1', message: type==3?msg:name,date: formatDate( DateTime.now(),'yyyy-MM-dd h:mm a',"es_CO"), typeMessage: type,photo: "",isLocal: true,urlFile: msg,);
          providerChat.addMessages = message;
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }

  messageReceiveType(String? type){
    switch (type) {
      case Constants.typeSeller:
        socketService.socket!.on('messageSellerUser', messageReceive);
        break;
      case Constants.typeProvider:
        socketService.socket!.on('messageProviderUser', messageReceive);
        break;
      case Constants.typeAdmin:
        socketService.socket!.on('messageAdminUser', messageReceive);
        break;
    }
  }

  String typeEmit(String? type){
    switch (type) {
      case Constants.typeSeller:
        return "messageSellerUser";
      case Constants.typeProvider:
        return 'messageProviderUser';
      case Constants.typeAdmin:
        return "messageAdminUser";
      default:
        return "";
    }
  }

  getRoomProvider(String providerId,String subOrderId) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callChat = providerChat.getRomProvider(subOrderId, providerId);
        await callChat.then((id) {
          if(socketService.serverStatus!=ServerStatus.Online){
            socketService.connectSocket(Constants.typeProvider, id,subOrderId);
          }
          providerChat.setMessagesListAdmin(widget.imageProfile??'');
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

  getRoomSupport() async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callChat = providerChat.getRomAdmin();
        await callChat.then((id) async {
          if(socketService.serverStatus!=ServerStatus.Online){
            socketService.connectSocket(Constants.typeAdmin, id,"");
          }
          providerChat.setMessagesListAdmin(widget.imageProfile??'');
         }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }


  getRoomSeller(String sellerId,String orderId,String imageSeller) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callChat = providerChat.getRomSeller(sellerId, orderId);
        await callChat.then((id) {
          if(socketService.serverStatus!=ServerStatus.Online){
            socketService.connectSocket(Constants.typeSeller, id,orderId);
          }
          providerChat.setMessagesListAdmin(widget.imageProfile??'');
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBarError(context, Strings.loseInternet);
      }
    });
  }

}