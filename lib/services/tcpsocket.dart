import 'dart:async';
import 'dart:io';

class TcpSocket {
  Socket socket;

 Future<int> connect(String iPaddress, int port) async {
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
            return -1;
          },
          );
          // socket.write('{"request":"state"}');
    });
    return 0;
  }

  Future<String> receive(){
    var streamdata;
    socket.listen((data){
      streamdata = data;
    });
    return streamdata;
  }

  sendmessage(String message) {
    socket.write(message);
  }

}
