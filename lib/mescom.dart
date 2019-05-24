import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waterlevel/bloc/energy_provider.dart';

class MescomPage extends StatelessWidget {

  @override
  Widget build(context) {
    return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            centerTitle: true,
            title: Text('MESCOM'),
          ),
          body: new Mescomdata(),
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
    energymon.sendmessage('#2');
    return Container(
      child: Column(
        children: <Widget>[
          buildCard(energymon),
        ],
      ),
    );
  }

  Widget buildCard(EnergyMon energymon) {
    double amount = 0;
    double watt = double.parse(energymon.getenergy);
    amount = (watt / 10) * 12;
    String subheader = '${amount.toStringAsFixed(2)} /- Rs';
    return GestureDetector(
      onTap: () {
        energymon.sendmessage("#2");
      },
      child: Card(
          elevation: 10,
          child: Container(
              margin: EdgeInsets.all(15),
              width: 1000,
              height: 200,
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
                  Text(
                    'Bill Amount: $subheader',
                    style: TextStyle(fontSize: 20),
                  ),
                  Divider(),
                  Center(
                    child: RaisedButton(
                      color: Colors.red,
                      onPressed: () {
                        energymon.sendmessage('#1');
                      },
                      child: Text(
                        'DISCONNECT',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ))),
    );
  }
}
