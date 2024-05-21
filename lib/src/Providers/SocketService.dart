import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:wawamko/src/Utils/Constants.dart';
import 'package:wawamko/src/Utils/share_preference.dart';


enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier {

  final prefsUser = SharePreference();
  bool _isLoading = false;
  bool get isLoading => this._isLoading;
  set isLoading(bool value) {
    this._isLoading = value;
    notifyListeners();
  }

  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket? _socket;

  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket? get socket => this._socket;
  Function get emit => this._socket!.emit;

  void connectSocket(String typeJoin,String? idRoom,String idOrder) {
    this._socket = IO.io(Constants.urlSocket, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew':true
    });

    this._socket!.on('connect', (value) {
      this._serverStatus = ServerStatus.Online;
      connectToRoom(typeJoin, idRoom,idOrder);
      notifyListeners();
    });

    this._socket!.on('disconnect', (value) {
      print('error conectado con el socket: $value');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    this._socket!.on('error', (error) {
      print('error en el socket: $error');
    });

    this._socket!.on('connect_error', (error) {
      print('error conectado con el socket: $error');
    });

  }

  void disconnectSocket(){
    print('desconectado');
    this._socket?.disconnect();
  }

  connectToRoom(String type,String? room,String idOrder){
    switch (type) {
      case Constants.typeSeller:
        _socket!.emit('joinRoomSellerUser', {json.encode({
          'room':room,
          'orderId':idOrder,
          'transmitterId':prefsUser.userID,
          'typeUser': 'user'
        })});
        print('conectado al seller');
        break;
      case Constants.typeProvider:
        _socket!.emit('joinRoomProviderUser', {json.encode({
          'room':room,
          'suborderId':idOrder,
          'transmitterId':prefsUser.userID,
          'typeUser': 'user'
        })});
        print('conectado al provedor');
        break;
      case Constants.typeAdmin:
        _socket!.emit('joinRoomAdminUser', {json.encode({'room': room, 'transmitterId': prefsUser.userID, 'typeUser': 'user'})});
        print('conectado al admin');
        break;
    }
  }

}