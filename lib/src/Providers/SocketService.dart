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
  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  void connectSocket() {
    this._socket = IO.io(Constants.urlSocket, {
      'transports': ['websocket'],
      'autoConnect': true
    });

    this._socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;
      print('conectado');
      notifyListeners();
    });

    this._socket.on('disconnect', (value) {
      print(value.toString());
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    this._socket.on('error', (error) {
      print('error en el socket: $error');
    });

    this._socket.on('connect_error', (error) {
      print('error conectado con el socket: $error');
    });

  }

  void disconnectSocket(){
    print('desconectado');
    this._socket?.disconnect();
  }

}