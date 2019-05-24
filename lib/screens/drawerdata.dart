import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:waterlevel/bloc/energy_provider.dart';

class DrawerData extends StatelessWidget {
  const DrawerData({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _ipaddress = new TextEditingController();
    final TextEditingController _port = new TextEditingController();
    final energymon = Provider.of<EnergyMon>(context);
    return Drawer(
      child: GestureDetector(
        onTap: () {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        },
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 100.0, left: 30, right: 30),
            child: Column(
              children: <Widget>[
                buildIPaddress(_ipaddress, energymon.ipaddress),
                buildPort(_port, energymon.port),
                buildConnectbtn(_ipaddress, _port, energymon),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding buildConnectbtn( TextEditingController _ipaddress,
      TextEditingController _port, EnergyMon energymon) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        elevation: 10.0,
        color: Colors.grey,
        child: Container(
          height: 40.0,
          width: 130.0,
          child: Center(
            child: Text(
              'CONNECT',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        onPressed: () {
          // bloc.setIP(_ipaddress.text, int.parse(_port.text));
          // bloc.updateData(_ipaddress.text, int.parse(_port.text));
          energymon.setIP(_ipaddress.text, int.parse(_port.text));
          energymon.clientconnect(_ipaddress.text, 9999);
        },
      ),
    );
  }

  Padding buildPort(TextEditingController _port, int port) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _port,
        keyboardType: TextInputType.numberWithOptions(),
        decoration:
            InputDecoration(labelText: 'Port', hintText: '$port'),
      ),
    );
  }

  Padding buildIPaddress(
      TextEditingController _ipaddress, String ipaddress) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _ipaddress,
        keyboardType: TextInputType.numberWithOptions(),
        decoration: InputDecoration(
            labelText: 'IP Address', hintText: '$ipaddress'),
      ),
    );
  }
}
