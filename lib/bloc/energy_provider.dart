import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnergyMon with ChangeNotifier {
  EnergyMon();
  String rrnumber = '';
  String energy = '0.0';

  bool tcpconnected = false;
  bool get gettcpconnected => tcpconnected;
  String get getRR => rrnumber;
  String get getenergy => energy;

  Socket client;
  String ipaddress;
  int port = 9999;

  String get getIP => ipaddress;
  int get getPORT => port;


  void setIP(String ipadd, int tport) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('ip', ipadd);
    prefs.setInt('port', tport);

  }

  void connect(String ipAddress, int port) async{
    Socket.connect(ipAddress, port).then((sock) {
      print('client connected');
      tcpconnected = true;
      notifyListeners();
      client = sock;
      sock.listen((data) {
        _handledata(String.fromCharCodes(data).trim());
      });
    });
  }
  void _handledata(String data) {
    if (data[0] == '*') {
      rrnumber = data.replaceFirst('*', '');
      print('RR number: $rrnumber');
    } else if (data[0] == '#') {
      energy = data.replaceFirst('#', '');
      print('Energy units: $energy kW');
    }
    notifyListeners();
  }

  void sendmessage(String message){
    if(tcpconnected){
    client.write(message);
    print('sending data');
    } else {
    print('sending failed, tcp not connected');
    }
  }

  void send(String iPaddress, int port, String message) {
    Socket.connect(iPaddress, port).then((sock) {
      sock.write(message);
      print('sending data');
      sock.listen((data) {
        _handledata(String.fromCharCodes(data).trim());
      });
    });
  }

  void disconnect() {
    client.destroy();
    tcpconnected = false;
    notifyListeners();
  }
}



/*
  int connect() {
    ServerSocket.bind(InternetAddress.anyIPv4, 9999).then((server) {
      server.listen((clients) {
        client = clients;
        clients.listen((data) {
          _handledata(String.fromCharCodes(data).trim());
        });
      });
    });
    return 0;
  }
*/