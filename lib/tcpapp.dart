import 'package:flutter/material.dart';
import 'package:waterlevel/services/tcpsocket.dart';

class TcpApp extends StatefulWidget {
  @override
  TcpAppState createState() {
    return new TcpAppState();
  }
}

class TcpAppState extends State<TcpApp> {
  var tcpsock = new TcpSocket();
  Future<String> message;

  void initState() {
    super.initState();
    tcpsock.connect();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        child: Column(
          children: <Widget>[
            connectbutton(),
            FutureBuilder<Object>(
                future: message,
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return Center(child: Text('snapshot.data'));
                  return Center(child: CircularProgressIndicator());
                }),
          ],
        ),
      ),
    );
  }

Widget connectbutton() {
  return Padding(
    padding: const EdgeInsets.only(top:80.0),
    child: RaisedButton(elevation: 10.0,
    onPressed: (){
      // tcpsock.tcpSend('192.168.1.43', 9999,'requesting data');
    },
    child: Text('Connect'),),
  );
}
}
