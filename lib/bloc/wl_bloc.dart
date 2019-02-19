import 'dart:async';
import 'dart:io';
import 'package:waterlevel/bloc/bloc_provider.dart';

class WaterLevelBloc implements BlocBase {
  Socket client;

  int tlevel; //level 1 to 4 of tank level
  int slevel; //level 1 to 4 of sump level
  int pumpstate; // 0 or 1

  StreamController<String> _tcpsocket = StreamController<String>();
  Stream<String> get tcprecieve => _tcpsocket.stream;
  StreamSink<String> get tcpdata => _tcpsocket.sink;

  // WaterLevelBloc() {}

  void connect() {
    ServerSocket.bind(InternetAddress.anyIPv4, 9999).then((server) {
      print('${server.address} , ${server.port}');
      server.listen((clients) {
        client = clients;
        client.listen((data) {
          print(String.fromCharCodes(data).trim());
          tcpdata.add(String.fromCharCodes(data).trim());
        });
      });
    });
  }

  void clientconnect(String ipAddress, int port) {
    Socket.connect(ipAddress, port).then((sock) {
      print('${sock.remoteAddress} , ${sock.remotePort}');
      client = sock;
      sock.listen((data) {
        
        print(String.fromCharCodes(data).trim());
        tcpdata.add(String.fromCharCodes(data).trim());
      });

    });
  }

  void send(String message) {
    client.write(message);
  }

  void dispose() {
    _tcpsocket.close();
  }
}
