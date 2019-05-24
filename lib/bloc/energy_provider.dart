import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EnergyMon with ChangeNotifier {
  EnergyMon();
  String rrnumber = '';
  String username = '';
  String energy = '';

  String get getRR => rrnumber;
  String get getenergy => energy;

  Socket client;
  String ipaddress = '192.168.1.40';
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

  void updateData(String ipAddress, int port) async {
    await Firestore.instance
        .collection('waterlevel')
        .document('activate')
        .updateData({'ipaddress': ipAddress, 'port': port});
  }

  void setIP(String ip, int textport) {
    ipaddress = ip;
    port = textport;
  }

  void clientconnect(String ipAddress, int port) {
    if (ipaddress == null) ipaddress = ipAddress;
    Socket.connect(ipaddress, port).then((sock) {
      client = sock;
      sock.listen((data) {
        _handledata(String.fromCharCodes(data).trim());
      });
    });
  }

  void _handledata(String data) {
    if (data[0] == '#') {
      rrnumber = data;
      print('RR number: $rrnumber');
    } else if (data[0] == '*') {
      energy = data;
      print('Energy units: $energy kW');
    }
    notifyListeners();
  }

  void send(String iPaddress, int port, String message) {
    Socket.connect(iPaddress, port).then((sock) {
      sock.write(message);
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
