import 'package:flutter/material.dart';
import 'package:waterlevel/bloc/bloc_provider.dart';
import 'package:waterlevel/bloc/wl_bloc.dart';
import 'package:waterlevel/screens/drawerdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class HomePage extends StatelessWidget {
  final act = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<WaterLevelBloc>(context);
    // bloc.connect();
    return Dash(bloc: bloc);
  }
}

class Dash extends StatelessWidget {
  const Dash({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  final WaterLevelBloc bloc;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('waterlevel').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bloc.setIP(snapshot.data.documents[0].data['ipaddress'],
                snapshot.data.documents[0].data['port']);
            bloc.send(bloc.ipaddress, bloc.port, '{"request":"level"}');
            bloc.send(bloc.ipaddress, bloc.port, '{"request":"state"}');
            if (snapshot.data.documents[0].data['registered']) {
              return Scaffold(
                key: _scaffoldKey,
                drawer: new DrawerData(),
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: Text('Water Level Controller'),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: new PumpButton(bloc: bloc),
                bottomNavigationBar: BottomAppBar(
                  shape: CircularNotchedRectangle(),
                  notchMargin: 4.0,
                  child: Container(
                    height: 80.0,
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () {
                            _scaffoldKey.currentState.openDrawer();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 45.0),
                          child: Text(
                            'PUMP',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: () {
                            bloc.send(bloc.ipaddress, bloc.port,
                                '{"request":"level"}');
                            bloc.send(bloc.ipaddress, bloc.port,
                                '{"request":"state"}');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                body: ListView(
                  children: <Widget>[
                    StreamBuilder<int>(
                        stream: bloc.tlevelstream,
                        initialData: 1,
                        builder: (context, snapshot) {
                          Color level4 = Colors.blue[200];
                          Color level3 = Colors.blue[400];
                          Color level2 = Colors.blue[600];
                          Color level1 = Colors.blue[800];
                          if (snapshot.data == 1) {
                            level4 = Colors.transparent;
                            level3 = Colors.transparent;
                            level2 = Colors.transparent;
                          } else if (snapshot.data == 2) {
                            level4 = Colors.transparent;
                            level3 = Colors.transparent;
                          } else if (snapshot.data == 3) {
                            level4 = Colors.transparent;
                          }

                          return LevelCards(
                              config: CustomConfig(
                                colors: [level4, level3, level2, level1],
                                durations: [25000, 18000, 12000, 5000],
                                heightPercentages: [0.01, 0.30, 0.60, 0.80],
                              ),
                              bloc: bloc,
                              title: 'TANK',
                              level: snapshot.data);
                        }),
                    StreamBuilder<int>(
                        stream: bloc.slevelstream,
                        initialData: 1,
                        builder: (context, snapshot) {
                          Color level4 = Colors.blue[200];
                          Color level3 = Colors.blue[500];
                          Color level2 = Colors.blue[700];
                          Color level1 = Colors.blue[800];
                          // Color level4 = Color(0xFFAED9D7);
                          // Color level3 = Color(0xFF3DDAD7);
                          // Color level2 = Color(0xFF2A93D5);
                          // Color level1 = Color(0xFF135589);
                          if (snapshot.data == 1) {
                            level4 = Colors.transparent;
                            level3 = Colors.transparent;
                            level2 = Colors.transparent;
                          } else if (snapshot.data == 2) {
                            level4 = Colors.transparent;
                            level3 = Colors.transparent;
                          } else if (snapshot.data == 3) {
                            level4 = Colors.transparent;
                          }
                          return LevelCards(
                              config: CustomConfig(
                                colors: [level4, level3, level2, level1],
                                durations: [32000, 27000, 16000, 7000],
                                heightPercentages: [0.01, 0.25, 0.50, 0.70],
                              ),
                              bloc: bloc,
                              title: 'SUMP',
                              level: snapshot.data);
                        })
                  ],
                ),
              );
            } else
              Center(child: CircularProgressIndicator());
          } else
            Center(child: CircularProgressIndicator());
        });
  }
}

class PumpButton extends StatelessWidget {
  const PumpButton({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  final WaterLevelBloc bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: bloc.statestream,
        builder: (context, snapshot) {
          if (snapshot.data == 1) {
            return pumpbutton(bloc, 'ON', Colors.blue[300]);
          } else {
            return pumpbutton(bloc, 'OFF', Colors.red);
          }
        });
  }
}

class LevelCards extends StatelessWidget {
  const LevelCards({
    Key key,
    @required this.bloc,
    @required this.title,
    @required this.level,
    @required this.config,
  }) : super(key: key);

  final WaterLevelBloc bloc;
  final String title;
  final int level;
  final CustomConfig config;

  @override
  Widget build(BuildContext context) {
    String leveltitle;
    if (level == 1)
      leveltitle = 'Empty';
    else if (level == 2)
      leveltitle = 'Half';
    else if (level == 3)
      leveltitle = 'Almost Full';
    else if (level == 4) leveltitle = 'Full';
    return Stack(children: <Widget>[
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 8.0,
        margin: EdgeInsets.only(top: 70.0, left: 15.0, right: 15.0),
        child: SizedBox(
          height: 200.0,
          width: 400,
          child: buildWave(config: config, backgroundColor: Colors.white),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 45),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30), color: Colors.blue),
            width: 140,
            height: 50,
            child: Center(
              child: Text(
                title,
                style: TextStyle(fontSize: 25.0, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
      Positioned(
        top: 110,
        left: 30,
        child: Container(
          height: 120,
          width: 120,
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              leveltitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 30,
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}

Widget pumpbutton(WaterLevelBloc bloc, String s, Color color) {
  int toggle = 1;
  if (s == 'ON') toggle = 0;
  return Container(
    height: 80,
    width: 80,
    child: FloatingActionButton(
      backgroundColor: color,
      foregroundColor: Colors.white,
      tooltip: 'Pump Control',
      child: Text(
        s,
        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        bloc.send(bloc.ipaddress, bloc.port, '{"pump":$toggle}');
        // print('$s button pressed');
      },
    ),
  );
}

Widget buildWave({Config config, Color backgroundColor = Colors.transparent}) {
  return ClipRRect(
    borderRadius: new BorderRadius.circular(20.0),
    child: WaveWidget(
      config: config,
      backgroundColor: backgroundColor,
      size: Size(double.infinity, double.infinity),
      waveAmplitude: 2,
    ),
  );
}
