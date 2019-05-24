import 'dart:io';
import 'package:flutter/material.dart';

class EnergyMon with ChangeNotifier {
  EnergyMon();
  String rrnumber = '';
  String username = '';
  String energy = '';

  String get getRR => rrnumber;
  String get getenergy => energy;

  Socket client;
  String ipaddress = '192.168.1.43';
  int port = 9999;

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

  // void updateData(String ipAddress, int port) async {
  //   await Firestore.instance
  //       .collection('waterlevel')
  //       .document('activate')
  //       .updateData({'ipaddress': ipAddress, 'port': port});
  // }

  void setIP(String ip, int textport) {
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
      }, onDone: () {

      }
      );
    });
  }

  void _handledata(String data) {
    if (data[0] == '#') {
      rrnumber = data.replaceFirst('#','');
      print('RR number: $rrnumber');
    } else if (data[0] == '*') {
      energy = data.replaceFirst('*','');
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
      }, onDone: () {
        sock.destroy();
      });
    });
  }

  void disconnect() {
    client.destroy();
  }
}
