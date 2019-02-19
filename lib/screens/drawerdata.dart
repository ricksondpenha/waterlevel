import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DrawerData extends StatelessWidget {
  const DrawerData({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: GestureDetector(
        onTap: () {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        },
        child: Container(
          color: Colors.blueGrey,
          child: Padding(
            padding: const EdgeInsets.only(top: 100.0, left: 30, right: 30),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(labelText: 'IP Address'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(labelText: 'Port'),
                  ),
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  elevation: 10.0,
                  color: Colors.white30,
                  child: Container(
                    height: 40.0,
                    width: 130.0,
                    child: Center(
                      child: Text(
                        "CONNECT",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    print('connect pressed');
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
