import 'package:flutter/material.dart';
import 'package:waterlevel/bloc/bloc_provider.dart';
import 'package:waterlevel/bloc/wl_bloc.dart';
import 'package:waterlevel/screens/drawerdata.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AirQualityBloc>(context);
    // bloc.connect();
    return Dash(bloc: bloc);
  }
}

class Dash extends StatelessWidget {
  const Dash({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  final AirQualityBloc bloc;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      drawer: new DrawerData(),
      appBar: _topAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: new PumpButton(bloc: bloc),
      bottomNavigationBar: _bottomAppBar(_scaffoldKey),
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('waterlevel').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              bloc.setIP(snapshot.data.documents[0].data['ipaddress'],
                  snapshot.data.documents[0].data['port']);
              bloc.send(bloc.ipaddress, bloc.port, '{"request":"level"}');
              bloc.send(bloc.ipaddress, bloc.port, '{"request":"state"}');
              if (snapshot.data.documents[0].data['registered']) {
                return _airlevel();
              } else
                return Center(child: CircularProgressIndicator());
            } else
              return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget _airlevel() {
    return ListView(
      children: <Widget>[
        templevel(),
        mq15_level(),
        dust_level(),
      ],
    );
  }

  Widget templevel() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 8.0,
      margin: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
      child: Column(
        children: <Widget>[
          Center(
            child: StreamBuilder<String>(
              stream: bloc.tempstream,
              // initialData: 1,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Text(
                  'TEMPERATURE LEVEL:${snapshot.data}',
                  style: TextStyle(fontSize: 20),
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: StreamBuilder<String>(
              stream: bloc.humidtream,
              // initialData: 1,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Text(
                  'HUMIDITY LEVEL:${snapshot.data}',
                  style: TextStyle(fontSize: 20),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget mq15_level() {
    return StreamBuilder<String>(
      stream: bloc.mq15stream,
      // initialData: 1,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 8.0,
          margin: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
          child: Center(
            child: Text(
              'MQ15 LEVEL:${snapshot.data}',
              style: TextStyle(fontSize: 20),
            ),
          ),
        );
      },
    );
  }

  Widget dust_level() {
    return StreamBuilder<String>(
      stream: bloc.duststream,
      // initialData: 1,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 8.0,
          margin: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
          child: Center(
            child: Text(
              'DUST LEVEL:${snapshot.data}',
              style: TextStyle(fontSize: 20),
            ),
          ),
        );
      },
    );
  }

  AppBar _topAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text('Air Quality Monitor'),
    );
  }

  BottomAppBar _bottomAppBar(GlobalKey<ScaffoldState> _scaffoldKey) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: Container(
        height: 80.0,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: IconButton(
                icon: Icon(
                  Icons.menu,
                  size: 50.0,
                ),
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 45.0),
              child: Text(
                'Air Purifier',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40.0),
              child: IconButton(
                icon: Icon(
                  Icons.refresh,
                  size: 50.0,
                ),
                onPressed: () {
                  bloc.send(bloc.ipaddress, bloc.port, '{"request":"level"}');
                  bloc.send(bloc.ipaddress, bloc.port, '{"request":"state"}');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PumpButton extends StatelessWidget {
  const PumpButton({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  final AirQualityBloc bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: bloc.controlstream,
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

  final AirQualityBloc bloc;
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

Widget pumpbutton(AirQualityBloc bloc, String s, Color color) {
  int toggle = 1;
  if (s == 'ON') toggle = 0;
  return Container(
    height: 80,
    width: 80,
    child: FloatingActionButton(
      backgroundColor: color,
      foregroundColor: Colors.white,
      tooltip: 'Air Purifier Control',
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
