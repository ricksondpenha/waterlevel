import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:waterlevel/screens/drawerdata.dart';
import 'package:provider/provider.dart';
import 'bloc/energy_provider.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

Future<void> main() async {
  /// Obtain instance to streaming shared preferences, create MyAppSettings, and
  /// once that's done, run the app.
  final preferences = await StreamingSharedPreferences.instance;

  runApp(MyApp(preferences));
}

class MyApp extends StatelessWidget {
  MyApp(this.preferences);
  final StreamingSharedPreferences preferences;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData.dark(), home: Loginpage(preferences));
  }
}

class Loginpage extends StatelessWidget {
  Loginpage(this.preferences);
  final StreamingSharedPreferences preferences;
  @override
  Widget build(BuildContext context) {
    var emon = EnergyMon();
    Preference<String> ipaddress = preferences.getString('ip', defaultValue: '192.168.1.43');
    ipaddress.listen((value) {
      emon.clientconnect(value, 9999);
      // emon.send(value, 9999, 'req');
    });

    return ChangeNotifierProvider<EnergyMon>(
      builder: (_) => EnergyMon(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text('E-Meter'),
        ),
        drawer: new DrawerData(),
        body: new HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MescomPage(context)),
              );
            },
            child: Card(
                elevation: 10,
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage("assets/mescom.png"),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    width: 1000,
                    height: 200,
                    child: null)),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserPage()),
              );
            },
            child: Card(
                elevation: 10,
                child: Container(
                    alignment: Alignment(0.0, 1.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage("assets/user.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: 1000,
                    height: 200,
                    child: Text(
                      'USER',
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ))),
          )
        ],
      ),
    );
  }
}

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EnergyMon>(
      builder: (_) => EnergyMon(),
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            centerTitle: true,
            title: Text('USER'),
          ),
          body: new Userdata()),
    );
  }
}

class Userdata extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final energymon = Provider.of<EnergyMon>(context);

    
    return Container(
        width: 1000,
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            buildCard(energymon, 'energy'),
            buildCard(energymon, 'bill'),
          ],
        ));
  }

  Widget buildCard(EnergyMon energymon, String type) {
    String imagepath;
    String header;
    String subheader;
    if (type == 'energy') {
      imagepath = "assets/energy.png";
      header = 'Energy Consumed:';
      subheader = '${energymon.getenergy} kW';
    } else if (type == 'bill') {
      imagepath = "assets/rupee.jpeg";
      header = 'Total Bill:';
      double amount = 0;
      double watt = double.parse(energymon.getenergy);
      amount = (watt/1000 )* 5.5;
      subheader = '$amount /- Rs';
    }
    return GestureDetector(
      onTap: (){
        energymon.send(energymon.getIP, 9999, '*');
      },
          child: Card(
          elevation: 10,
          child: Container(
              width: 1000,
              height: 150,
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10),
                    child: CircleAvatar(
                      foregroundColor: Colors.black26,
                      radius: 50,
                      backgroundImage: AssetImage(imagepath),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        header,
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Divider(),
                      Text(
                        subheader,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  )
                ],
              ))),
    );
  }
}

class MescomPage extends StatelessWidget {
  MescomPage(BuildContext context);

  @override
  Widget build(context) {
    return ChangeNotifierProvider<EnergyMon>(
      builder: (_) => EnergyMon(),
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            centerTitle: true,
            title: Text('MESCOM'),
          ),
          body: new Mescomdata()),
    );
  }
}

class Mescomdata extends StatelessWidget {
  const Mescomdata({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final energymon = Provider.of<EnergyMon>(context);
    return Container(
      child: Column(
        children: <Widget>[
          buildCard(energymon),
        ],
      ),
    );
  }

  Widget buildCard(EnergyMon energymon) {
    return GestureDetector(
      onTap: (){
        energymon.send(energymon.getIP, 9999, '*');
      },
          child: Card(
          elevation: 10,
          child: Container(
              margin: EdgeInsets.all(15),
              width: 1000,
              height: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'RR Number: ${energymon.getRR}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  Text(
                    'Energy Consumed: ${energymon.getenergy} kW',
                    style: TextStyle(fontSize: 20),
                  ),
                  Divider(),
                  Center(
                    child: RaisedButton(
                      color: Colors.red,
                      onPressed: () {
                        energymon.send(energymon.getIP, 9999, '#1');
                      },
                      child: Text(
                        'DISCONNECT',
                        style:
                            TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ))),
    );
  }
}
