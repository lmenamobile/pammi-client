import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wawamko/src/Providers/ProviderChat.dart';
import 'package:wawamko/src/Providers/SocketService.dart';
import 'package:wawamko/src/Utils/FunctionsFormat.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/share_preference.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/WidgetsGeneric.dart';
import 'WidgetsChat/MessageChat.dart';

class ChatPage extends StatefulWidget {
  final String roomId,orderId,subOrderId;
  const ChatPage({this.roomId, this.orderId, this.subOrderId});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ProviderChat providerChat;
  SocketService socketService;
  final prefs = SharePreference();
  final messageController = TextEditingController();
  final focusMessage = FocusNode();
  List<MessageChat> ltsMessages = [
  ];

  @override
  void initState() {
    super.initState();
    socketService = Provider.of<SocketService>(context,listen: false);
    socketService.socket.on('messageSellerUser', messageReceive);
  }

  @override
  Widget build(BuildContext context) {
    providerChat = Provider.of<ProviderChat>(context);
    return Scaffold(
      backgroundColor: CustomColors.redTour,
      body: SafeArea(
        child: Container(
          color: CustomColors.whiteBackGround,
          child: Column(
            children: [
              titleBar(Strings.chat, "ic_blue_arrow.png", () => Navigator.pop(context)),
              SizedBox(height: 20,),
              Expanded(
                  child:ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: ltsMessages.length,
                    reverse: true,
                    itemBuilder: (_,i)=>ltsMessages[i],
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

  handleSummit(String text){
    if(text.isNotEmpty) {
      messageController.clear();
      focusMessage.requestFocus();
      final message = MessageChat(uidUser: '1', message: text.toString().trim(),date: formatDate( DateTime.now(),'yyyy-MM-dd h:mm a',"es_CO"), typeMessage: 1,photo:'',);
      this.ltsMessages.insert(0,message);
      setState(() {});
      this.socketService.emit('messageSellerUser', { json.encode({
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
        this.ltsMessages.insert(0,message);
        break;
      case "image":
        final message = MessageChat(uidUser: '1', message:data['message'],date: formatDate( DateTime.now(),'yyyy-MM-dd h:mm a',"es_CO"), typeMessage: 3,photo: data['image'],isLocal: false,);
        this.ltsMessages.insert(0,message);
        break;
      case "file":
        final message = MessageChat(uidUser: '1', message:data['message'],date: formatDate( DateTime.now(),'yyyy-MM-dd h:mm a',"es_CO"), typeMessage: 4,photo: data['image'],isLocal: false,);
        this.ltsMessages.insert(0,message);
        break;

    }
    setState(() {});
  }


  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc','docx'],
    );
    if (result != null) {
      File file = File(result.files.single.path ?? "");
      serviceUpdatePhoto(file,result.files.single.name,4);
    }
  }

  void _handleImageSelection() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );
    if (result != null) {
      File file = File(result.files.single.path ?? "");
      serviceUpdatePhoto(file,"",3);
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

  serviceUpdatePhoto(File file,String name,int type) async {
    utils.checkInternet().then((value) async {
      if (value) {
        Future callUser = providerChat.serviceSendFile(file);
        await callUser.then((msg) {
          final message = MessageChat(uidUser: '1', message: type==3?msg:name,date: formatDate( DateTime.now(),'yyyy-MM-dd h:mm a',"es_CO"), typeMessage: type,photo: "",isLocal: true,);
          this.ltsMessages.insert(0,message);
          if(type==3) {
            this.socketService.emit('messageSellerUser', {
              json.encode({
                'room': widget.roomId,
                'type': "image",
                'typeUser': "user",
                'message': json.encode(
                    {'name': widget.roomId, 'url': msg, "size": "100"})
              })}
            );
          }else{
            this.socketService.emit('messageSellerUser', {
              json.encode({
                'room': widget.roomId,
                'type': "file",
                'typeUser': "user",
                'message': json.encode(
                    {'name': name, 'url': msg, "size": "100"})
              })}
            );
          }
          setState(() {});
        }, onError: (error) {
          utils.showSnackBar(context, error.toString());
        });
      } else {
        utils.showSnackBar(context, Strings.internetError);
      }
    });
  }



}