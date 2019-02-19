import 'package:flutter/material.dart';
import 'package:waterlevel/bloc/bloc_provider.dart';
import 'package:waterlevel/bloc/wl_bloc.dart';
import 'package:waterlevel/screens/drawerdata.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  final bloc = BlocProvider.of<WaterLevelBloc>(context);
  bloc.clientconnect('192.168.1.101', 9999);
    String message;
    return Scaffold(
      drawer: new DrawerData(),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Water Level Controller'),
      ),
      body: Stack(
        children: <Widget>[
          _pipeline(),
          _overHeadTank(),
          _tanklevel(),
          _pumpControl(bloc),
          _undergroundSump(),
          _sumplevel(),
        ],
      ),
    );
  }

  Widget _overHeadTank() {
    return Positioned(
      top: 50,
      left: 130,
      child: Image.asset(
        'assets/tank.png',
      ),
    );
  }

  Widget _pumpControl(WaterLevelBloc bloc) {
    return Positioned(
        top: 300,
        left: 200,
        child: Container(
          height: 80,
          width: 80,
          child: StreamBuilder<String>(
            stream: bloc.tcprecieve,
            builder: (context, snapshot) {

              return FloatingActionButton(
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
                  bloc.send('message');
                  print('ON button pressed');
                },
              );
            }
          ),
        ));
  }

  Widget _undergroundSump() {
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

  Widget _tanklevel() {
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

  Widget _sumplevel() {
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

  Container _colorlevel() {
    return Container(
      height: 20,
      color: Colors.white10,
    );
  }

  Widget _pipeline() {
    Color color;
    if (true) color = Colors.blue;
    color = Colors.grey;
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

// Socket socket;

// void initState() {
//   super.initState();
// ServerSocket.bind(InternetAddress.anyIPv4, 9999).then((server) {
//   server.listen(handleClient);
// });
// }

// void handleClient(Socket client) {
//   print('Connection from '
//       '${client.remoteAddress.address}:${client.remotePort}');
//   client.listen(
//     (data) {
//       setState(() {
//         print(new String.fromCharCodes(data).trim());
//         message = String.fromCharCodes(data).trim();
//       });
//     },
//   );
// }
