import 'dart:async';
import 'dart:io';

class TcpSocket {
  ServerSocket socket;

 connect() async {
   
    ServerSocket.bind(InternetAddress.anyIPv4, 9999).then((server) {
      socket = server;
      // print('Connected to: '
      //     '${socket.remoteAddress.address}:${socket.remotePort}');
      server.listen(handleClient);
  });
 }

 String handleClient(Socket client){
   String message;
  print('Connection from '
    '${client.remoteAddress.address}:${client.remotePort}');
  client.listen((data) {
      print(new String.fromCharCodes(data).trim());
      message = String.fromCharCodes(data).trim();
    },
  );
  client.write("Hello from simple server!\n");
  return message;
}

  // Future<String> receive(){
  //   var streamdata;
  //   socket.listen((data){
  //     streamdata = data;
  //   });
  //   return streamdata;
  // }

  // sendmessage(String message) {
  //   socket.write(message);
  // }

  tcpSend(String iPaddress, int port, String message)async {
  Socket.connect(iPaddress, port).then((socket) {
    print('Connected to: '
      '${socket.remoteAddress.address}:${socket.remotePort}');
   
    //Establish the onData, and onDone callbacks
    // socket.listen((data) {
    //   print(new String.fromCharCodes(data).trim());
    // },
    // onDone: () {
    //   print("Done");
    //   socket.destroy();
    // });
  
    //Send the request
    socket.write(message);
    socket.destroy();
  });
  }

}

enum TcpState{
  connected,
  disconnected,
}
