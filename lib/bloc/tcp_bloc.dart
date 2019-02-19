// import 'dart:async';

// // import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:waterlevel/bloc/bloc_provider.dart';
// import 'package:waterlevel/repo/dbrepo.dart';
// import 'package:waterlevel/services/tcpsocket.dart';

// class TCPBloc implements BlocBase {
//     int tlevel; //level 1 to 4 of tank level
//     int slevel; //level 1 to 4 of sump level
//     int pumpstate;  // 0 or 1

//   StreamController<String> _tcpController = StreamController<String>();
//   StreamSink<String> get tcpSend => _tcpController.sink;
//   Stream<String> get tcpReceive => _tcpController.stream;

//   TcpBloc(){
//     _tcpController.stream.listen(db.connect());
//   }

//   void dispose(){
//     _tcpController.close();
//   }

//   void _handleLogic(data){
//     // _counter = _counter + 1;
//     // tcprecieve.add(_counter);
//   }
// }