import 'dart:math';

import 'package:waterlevel/services/tcpsocket.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';

class DB {
  final db = TcpSocket();

  Stream<String> connect() {
    return db.connect('192.168.1.43', 9999);
  }

  Future<String> createData(String question, List<String> answers) async {

  }

  void sendMessage(String message) async {

  }




 
}

DB db = DB();