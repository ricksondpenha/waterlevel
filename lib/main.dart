import 'package:flutter/material.dart';
import 'package:waterlevel/screens/drawerdata.dart';
import 'package:provider/provider.dart';
import 'bloc/energy_provider.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

Future<void> main() async {
  /// Obtain instance to streaming shared preferences, create MyAppSettings, and
  /// once that's done, run the app.
  final preferences = await StreamingSharedPreferences.instance;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData.dark(), home: Loginpage());
  }
}

class Loginpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EnergyMon>(
      builder: (_) {
        var energymon = EnergyMon();
        energymon.clientconnect('192.168.1.43', 9999);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text('E-Meter'),
        ),
        drawer: new DrawerData(),
        body: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MescomPage()),
                  );
                },
                child: Card(
                  elevation: 10,
                    child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/mescom.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        width: 1000,
                        height: 200,
                        child: Text('MESCOM'))),
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
                        child: Text('USER', style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold, color: Colors.white),))),
              )
            ],
          ),
        ),
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
    String amount = energymon.getenergy;

    // energymon.send('192.168.1.43', 9999, 'req');
    return Container(
        child: Column(
      children: <Widget>[
        Text('Energy Consumed: ${energymon.getenergy} kW'),
        Text('bill: $amount'),
      ],
    ));
  }
}

class MescomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          Text('RR number: ${energymon.getRR}'),
          Text('Energy Consumption: ${energymon.getenergy}'),
          RaisedButton(
            onPressed: () {
              energymon.send('192.168.1.40', 9999, 'disconnect');
            },
            child: Text('DISCONNECT'),
          ),
        ],
      ),
    );
  }
}
