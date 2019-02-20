import 'package:flutter/material.dart';
import 'package:waterlevel/bloc/bloc_provider.dart';
import 'package:waterlevel/bloc/wl_bloc.dart';
import 'package:waterlevel/screens/drawerdata.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<WaterLevelBloc>(context);
    bloc.connect();
    return Scaffold(
      drawer: new DrawerData(),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Water Level Controller'),
      ),
      body: GestureDetector(
        onTap: () {
          bloc.send(bloc.ipaddress, bloc.port, '{"request":"level"}');
        },
        child: Stack(
          children: <Widget>[
            _pipeline(bloc),
            _overHeadTank(),
            _tanklevel(bloc),
            _pumpControl(bloc),
            _undergroundSump(),
            _sumplevel(bloc),
          ],
        ),
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
          child: StreamBuilder<int>(
              stream: bloc.statestream,
              builder: (context, snapshot) {
                if (snapshot.data == 1) {
                  return pumpbutton(bloc, 'ON', Colors.blue);
                } else {
                  return pumpbutton(bloc, 'OFF', Colors.grey);
                }
              }),
        ));
  }

  Widget pumpbutton(WaterLevelBloc bloc, String s, Color color) {
    int toggle = 1;
    if (s == 'ON') toggle = 0;
    return FloatingActionButton(
      backgroundColor: color,
      foregroundColor: Colors.white,
      tooltip: 'Pump Control',
      child: Text(
        s,
        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        bloc.send(bloc.ipaddress, bloc.port, '{"pump":$toggle}');
        // bloc.statesink.add(toggle);
        print('$s button pressed');
      },
    );
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

  Widget _tanklevel(WaterLevelBloc bloc) {
    return Positioned(
        top: 85,
        left: 180,
        child: StreamBuilder<int>(
            stream: bloc.tlevelstream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data > 1)
                return Container(
                  height: 98,
                  width: 127,
                  color: Colors.blue,
                );
              else
                return Container(
                  height: 98,
                  width: 127,
                  color: Colors.grey,
                );
            }));
  }

  Widget _sumplevel(WaterLevelBloc bloc) {
    return Positioned(
        top: 440,
        left: 36,
        child: StreamBuilder<int>(
            stream: bloc.slevelstream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data > 1)
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
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10.0)),
                  height: 82,
                  width: 120,
                );
            }));
  }

  Container _colorlevel() {
    return Container(
      height: 20,
      color: Colors.white10,
    );
  }

  Widget _pipeline(WaterLevelBloc bloc) {
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
