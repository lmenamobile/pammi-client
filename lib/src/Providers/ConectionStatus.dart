import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';



class ConnectionAdmin {
  String _lookUpAddress = "www.google.com";
  static final ConnectionAdmin _singleton = ConnectionAdmin._internal();

  ConnectionAdmin._internal();
  static ConnectionAdmin getInstance() => _singleton;
  bool hasConnection = true;
  StreamController<bool> connectionChangeController = StreamController.broadcast();
  Stream<bool> get connectionListen => connectionChangeController.stream;
  final Connectivity _connectivity = Connectivity();
  void initialize(String lookUpAddress) {
    this._lookUpAddress = lookUpAddress;
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    checkConnection();
  }
  Stream get connectionChange => connectionChangeController.stream;
  void dispose() {
    connectionChangeController.close();
  }
  void _connectionChange(ConnectivityResult result) {
    Future.delayed(const Duration(milliseconds: 1000),(){ checkConnection();});
  }
  Future<bool> checkConnection() async {
    assert( _lookUpAddress != '');
    try {
      final result = await InternetAddress.lookup(_lookUpAddress);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }
    connectionChangeController.sink.add(hasConnection);
    return hasConnection;
  }
}