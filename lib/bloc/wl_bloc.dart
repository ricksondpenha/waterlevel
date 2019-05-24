import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:waterlevel/bloc/bloc_provider.dart';

class AirQualityBloc implements BlocBase {
  Socket client;

  String ipaddress = '192.168.1.40';
  int port = 9999;

  String methaneLevel; //level of MQ136 sensor
  String dustLevel; //level of Dust sensor
  String mq15Level; //level of MQ15 sensor
  String tempLevel; //temperature level of DHT sensor
  String humidLevel; //Humidity level of DHT sensor
  int purifiercontrol; //air purifier control OFF=0 & ON=1

  StreamController<String> _methaneLevel = StreamController<String>();
  Stream<String> get methanestream => _methaneLevel.stream;
  StreamSink<String> get methanesink => _methaneLevel.sink;

  StreamController<String> _dustLevel = StreamController<String>();
  Stream<String> get duststream => _dustLevel.stream;
  StreamSink<String> get dustsink => _dustLevel.sink;

  StreamController<String> _mq15Level = StreamController<String>();
  Stream<String> get mq15stream => _mq15Level.stream;
  StreamSink<String> get mq15sink => _mq15Level.sink;

  StreamController<String> _tempLevel = StreamController<String>();
  Stream<String> get tempstream => _tempLevel.stream;
  StreamSink<String> get tempsink => _tempLevel.sink;

  StreamController<String> _humidLevel = StreamController<String>();
  Stream<String> get humidtream => _humidLevel.stream;
  StreamSink<String> get humidsink => _humidLevel.sink;

  StreamController<int> _controlState = StreamController<int>();
  Stream<int> get controlstream => _controlState.stream;
  StreamSink<int> get controlsink => _controlState.sink;

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
    _methaneLevel.close();
    _dustLevel.close();
    _mq15Level.close();
    _tempLevel.close();
    _humidLevel.close();
    _controlState.close();
  }

  void _handledata(String data) {
    final jsonData = json.decode(data);
    if (jsonData['control'] != null) {
      purifiercontrol = jsonData['control'];
      print('Purifier Control value: $purifiercontrol');
      controlsink.add(purifiercontrol);
    } else if (jsonData['dust_level'] != null) {
      dustLevel = jsonData['dust_level'];
      methaneLevel = jsonData['methane_level'];
      tempLevel = jsonData['temp_level'];
      humidLevel = jsonData['humid_level'];
      mq15Level = jsonData['mq15_level'];

      methanesink.add(methaneLevel);
      dustsink.add(dustLevel);
      tempsink.add(tempLevel);
      humidsink.add(humidLevel);
      mq15sink.add(mq15Level);
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
