import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waterlevel/bloc/bloc_provider.dart';
import 'package:waterlevel/repo/dbrepo.dart';
import 'package:waterlevel/services/tcpsocket.dart';

class TCPBloc implements BlocBase {
    int tlevel; //level 1 to 4 of tank level
    int slevel; //level 1 to 4 of sump level
    int pumpstate;  // 0 or 1

  StreamController<int> _tcpController = StreamController<int>();
  StreamSink<int> get tcpReceive => _tcpController.sink;
  Stream<int> get tcpSend => _tcpController.stream;

  //
  // Stream to handle the action on the counter
  //
  StreamController _actionController = StreamController();
  StreamSink get incrementCounter => _actionController.sink;

  //
  // Constructor
  //
  TcpBloc(){
    // _counter = 0;
    // _actionController.stream
    //                  .listen(_handleLogic);
  }

  void dispose(){
    _actionController.close();
    _tcpController.close();
  }

  void _handleLogic(data){
    // _counter = _counter + 1;
    // tcprecieve.add(_counter);
  }
}