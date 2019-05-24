import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterlevel/mescom.dart';
import 'package:waterlevel/screens/drawerdata.dart';
import 'package:provider/provider.dart';
import 'package:waterlevel/user.dart';
import 'bloc/energy_provider.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EnergyMon>(
        builder: (_) => EnergyMon(),
        child: MaterialApp(
            theme: ThemeData.dark(),
            initialRoute: '/',
            routes: {
              '/mescom': (context) => MescomPage(),
              '/user': (context) => UserPage(),
            },
            home: Loginpage()));
  }
}

class Loginpage extends StatelessWidget {
  void lazyconnect(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ipadd = prefs.getString('ip');
    int port = prefs.getInt('port');
    print('ipaddress is $ipadd');
    print('port is $port');
    final energymon = Provider.of<EnergyMon>(context);
    energymon.ipaddress = ipadd;
    energymon.port = port;
    // energymon.connect(ipadd, port);
  }

  @override
  Widget build(BuildContext context) {
    lazyconnect(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text('E-Meter'),
      ),
      drawer: new DrawerData(),
      body: new HomePage(),
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
      margin: EdgeInsets.all(15),
      child: ListView(
        children: <Widget>[
          buildhomecards(context, '/mescom'),
          buildhomecards(context, '/user'),
        ],
      ),
    );
  }

  Future<void> _logindialog(BuildContext context, String type, String user) {
    final TextEditingController username = new TextEditingController();
    final TextEditingController password = new TextEditingController();
    String errortext = '';
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: username,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'username'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    obscureText: true,
                    controller: password,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'password'),
                  ),
                ),
                Center(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    elevation: 10.0,
                    color: Colors.green,
                    child: Container(
                      height: 40.0,
                      width: 160.0,
                      child: Center(
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (username.text == user && password.text == user)
                        Navigator.pushNamed(context, type);
                      else{
                        errortext = 'Invalid username & password!';
                      }
                    },
                  ),
                ),
                Text(errortext, style:TextStyle(color: Colors.red)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildhomecards(BuildContext context, String type) {
    String assetpath;
    Widget label;
    String user;
    String pass;
    if (type == '/mescom') {
      assetpath = "assets/mescom.png";
      label = null;
      user = 'mescom';
    } else {
      assetpath = "assets/user.png";
      user = 'user';
      label = Text(
        'USER',
        style: TextStyle(
            fontSize: 35, fontWeight: FontWeight.bold, color: Colors.red),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: GestureDetector(
        onTap: () {
          _logindialog(context, type, user);
        },
        child: Card(
            elevation: 10,
            child: Container(
                alignment: Alignment(0.0, 1.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage(assetpath),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                width: 1000,
                height: 200,
                child: label)),
      ),
    );
  }
}
