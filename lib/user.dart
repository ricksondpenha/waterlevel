import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterlevel/bloc/energy_provider.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            centerTitle: true,
            title: Text('USER'),
          ),
          body: new Userdata(),
    );
  }
}

class Userdata extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final energymon = Provider.of<EnergyMon>(context);
    energymon.sendmessage('#2');
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
      amount = (watt / 10) * 12;
      subheader = '${amount.toStringAsFixed(2)} /- Rs';
    }
    return GestureDetector(
      onTap: () {
        // energymon.send(energymon.getIP, 9999, '#2');
        energymon.sendmessage('#2');
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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

