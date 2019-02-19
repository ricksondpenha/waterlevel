import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waterlevel/bloc/bloc_provider.dart';
import 'package:waterlevel/bloc/tcp_bloc.dart';
import 'package:waterlevel/services/tcpsocket.dart';
import 'package:waterlevel/statemodel.dart';
import 'package:waterlevel/tcpapp.dart';

void main() => runApp(MyApp()); //MyApp()); //TcpApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  String message;
  Socket socket;

  void initState() {
    super.initState();
    ServerSocket.bind(InternetAddress.anyIPv4, 9999).then((server) {
      server.listen(handleClient);
    });
  }

  void handleClient(Socket client) {
    print('Connection from '
        '${client.remoteAddress.address}:${client.remotePort}');
    client.listen(
      (data) {
        setState(() {
          print(new String.fromCharCodes(data).trim());
          message = String.fromCharCodes(data).trim();
        });
      },
    );
  }

  Widget overHeadTank() {
    return Positioned(
      top: 50,
      left: 130,
      child: Image.asset(
        'assets/tank.png',
      ),
    );
  }

  Widget pumpControl() {
    return Positioned(
        top: 300,
        left: 200,
        child: Container(
          height: 80,
          width: 80,
          child: FloatingActionButton(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            tooltip: 'Pump Control',
            child: Text(
              'ON',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              // socket.write('{"request":"state"}');
              // tcpbloc.tcpSend.add('{"pump":1}');
              print('ON button pressed');
            },
          ),
        ));
  }

  Widget undergroundSump() {
    return Positioned(
      top: 400,
      left: 20,
      child: Image.asset(
        'assets/sump.png',
        width: 150.0,
        height: 150.0,
        // color: Colors.white,
      ),
    );
  }

  Widget tanklevel() {
    int level;
    return Positioned(
        top: 85,
        left: 180,
        child: StreamBuilder<String>(
            stream: null,
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return Container(
                  height: 98,
                  width: 127,
                  color: Colors.blue,
                );
              else
                return Container(
                  height: 98,
                  width: 127,
                  color: Colors.blue,
                );
            }));
  }

  Widget sumplevel() {
    return Positioned(
        top: 440,
        left: 36,
        child: StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10.0)),
                  height: 82,
                  width: 120,
                  child: Column(
                    children: <Widget>[
                      // colorlevel(),
                      // colorlevel(),
                      // colorlevel(),
                      // colorlevel()
                    ],
                  ),
                );
              else
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10.0)),
                  height: 82,
                  width: 120,
                  child: Column(
                    children: <Widget>[
                      // colorlevel(),
                      // colorlevel(),
                      // colorlevel(),
                      // colorlevel()
                    ],
                  ),
                );
            }));
  }

  Container colorlevel() {
    return Container(
      height: 20,
      color: Colors.white10,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        drawer: new DrawerData(),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Water Level Controller'),
        ),
        body: Stack(
          children: <Widget>[
            pipeline(),
            overHeadTank(),
            tanklevel(),
            pumpControl(),
            undergroundSump(),
            sumplevel(),
          ],
        ),
      ),
    );
  }

  Widget pipeline() {
    Color color;
    if(true){
      color = Colors.blue;
    } else{
      color = Colors.grey;
    }
    return Positioned(
      top: 90,
      left: 45,
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Container(
              color: color,
              width: 8.0,
              height: 370.0,
            ),
          ),
          Container(
            width: 135.0,
            height: 8.0,
            color: color,
          )
        ],
      ),
    );
  }
}

class DrawerData extends StatelessWidget {
  const DrawerData({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: GestureDetector(
        onTap: () {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        },
        child: Container(
          color: Colors.blueGrey,
          child: Padding(
            padding: const EdgeInsets.only(top: 100.0, left: 30, right: 30),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(labelText: 'IP Address'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(labelText: 'Port'),
                  ),
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  elevation: 10.0,
                  color: Colors.white30,
                  child: Container(
                    height: 40.0,
                    width: 130.0,
                    child: Center(
                      child: Text(
                        "CONNECT",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    print('connect pressed');
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
