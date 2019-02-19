import 'dart:io';

class TcpSocket {
  Socket socket;



  connect(String iPaddress, int port) async {
    Socket.connect(iPaddress, port).then((sock) {
      socket = sock;
      print('Connected to: '
          '${socket.remoteAddress.address}:${socket.remotePort}');
      socket.listen(
          (data) {
            print(new String.fromCharCodes(data).trim());
          },
          onError: () {
            print('error');
          },
          );
          // socket.write('{"request":"state"}');
    });
  }

  sendmessage(String message) {
    socket.write(message);
  }

}
