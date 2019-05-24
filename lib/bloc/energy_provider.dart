import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnergyMon with ChangeNotifier {
  EnergyMon();
  String rrnumber = '12345678';
  String energy = '0.0';

  String get getRR => rrnumber;
  String get getenergy => energy;

  Socket client;
  String ipaddress;
  int port = 9999;

  String get getIP => ipaddress;
  int get getPORT => port;

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

  void setIP(String ip, int textport) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ipaddd = (prefs.getString('ip'));
    await prefs.setString('ip', ip);
    ipaddress = ip;
    port = textport;
  }

  void clientconnect(String ipAddress, int port) {
    if (ipaddress == null) ipaddress = ipAddress;
    Socket.connect(ipaddress, port).then((sock) {
      print('client connected');
      client = sock;
      sock.listen((data) {
        _handledata(String.fromCharCodes(data).trim());
      });
    });
  }

  void _handledata(String data) {
    if (data[0] == '#') {
      rrnumber = data.replaceFirst('#', '');
      print('RR number: $rrnumber');
    } else if (data[0] == '*') {
      energy = data.replaceFirst('*', '');
      print('Energy units: $energy kW');
    }
    notifyListeners();
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
  }
}
