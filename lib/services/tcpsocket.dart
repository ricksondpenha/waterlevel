import 'dart:io';

class TcpSocket {
  Socket client;
  int port = 9999;
  connect() {
    ServerSocket.bind(InternetAddress.anyIPv4, port).then((server) {
      server.listen((clients) {
        client =clients;
        client.listen((data) {
          print(new String.fromCharCodes(data).trim());
        });
      });
    });
  }

  tcpSend(String message) {
      client.write(message);
  }
}