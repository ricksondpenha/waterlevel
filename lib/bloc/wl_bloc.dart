import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waterlevel/bloc/bloc_provider.dart';

class WaterLevelBloc implements BlocBase {
  Socket client;

  String ipaddress = '192.168.1.40';
  int port = 9999;

  int tlevel; //level 1 to 4 of tank level
  int slevel; //level 1 to 4 of sump level
  int pumpstate; // 0 or 1

  StreamController<int> _tlevel = StreamController<int>();
  Stream<int> get tlevelstream => _tlevel.stream;
  StreamSink<int> get tlevelsink => _tlevel.sink;

  StreamController<int> _slevel = StreamController<int>();
  Stream<int> get slevelstream => _slevel.stream;
  StreamSink<int> get slevelsink => _slevel.sink;

  StreamController<int> _state = StreamController<int>();
  Stream<int> get statestream => _state.stream;
  StreamSink<int> get statesink => _state.sink;

  int connect() {
    // if(iPaddress == null) iPaddress = '192.168.1.43';
    ServerSocket.bind(InternetAddress.anyIPv4, 9999).then((server) {
      // print('${server.address} , ${server.port}');
      server.listen((clients) {
        client = clients;
        clients.listen((data) {
          // print(String.fromCharCodes(data).trim());
          // tcpdata.add(String.fromCharCodes(data).trim());
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
        .updateData({'ipaddress':ipAddress, 'port':port});
  }

  void setIP(String ip, int textport) {
    ipaddress = ip;
    port = textport;
  }

  void clientconnect(String ipAddress, int port) {
    if (ipaddress == null) ipaddress = ipAddress;
    Socket.connect(ipaddress, port).then((sock) {
      // print('${sock.remoteAddress} , ${sock.remotePort}');
      client = sock;
      sock.listen((data) {
        // print(String.fromCharCodes(data).trim());
      });
    });
  }

  void send(String iPaddress, int port, String message) {
    Socket.connect(iPaddress, port).then((sock) {
      // print('${sock.remoteAddress} , ${sock.remotePort}');
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

  void dispose() {
    _tlevel.close();
    _slevel.close();
    _state.close();
  }

  void _handledata(String data) {
    final jsonData = json.decode(data);
    if (jsonData['pump'] != null) {
      pumpstate = jsonData['pump'];
      // print('Pump value: $pumpstate');
      statesink.add(pumpstate);
    } else if (jsonData['Slevel'] != null) {
      slevel = jsonData['Slevel'];
      tlevel = jsonData['Tlevel'];
      // print(
      //     'Tank level: ${tlevel.toString()}, Sump level: ${slevel.toString()}');
      slevelsink.add(slevel);
      tlevelsink.add(tlevel);
    }
  }
}

// WaterLevelBloc() {
// Socket.connect("192.168.1.43", 9999).then((socket) {
//   print('Connected to: '
//       '${socket.remoteAddress.address}:${socket.remotePort}');
//   client = socket;
//   //Establish the onData, and onDone callbacks
//   socket.listen((data) {
//     print(new String.fromCharCodes(data).trim());
//   });
// });

// ServerSocket.bind(InternetAddress.anyIPv4, 9999).then((server) {
//   print('${server.address} , ${server.port}');
//   server.listen((clients) {
//     client = clients;
//     clients.listen((data) {
//       print(String.fromCharCodes(data).trim());
//       // tcpdata.add(String.fromCharCodes(data).trim());
//       _handledata(String.fromCharCodes(data).trim());
//     });
//   });
// });
// }

// Socket.connect(iPaddress, 9999).then((socket) {
//   print('Connected to: '
//       '${socket.remoteAddress.address}:${socket.remotePort}');
//   client = socket;
//   //Establish the onData, and onDone callbacks
//   socket.listen((data) {
//     _handledata(String.fromCharCodes(data).trim());
//     print(new String.fromCharCodes(data).trim());
//   });
// }).catchError((onError) {
//   return -1;
// });
