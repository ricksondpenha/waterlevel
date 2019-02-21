// import 'package:flutter/material.dart';
// import 'package:waterlevel/bloc/wl_bloc.dart';

// Widget overHeadTank() {
//     return Positioned(
//       top: 50,
//       left: 130,
//       child: Image.asset(
//         'assets/tank.png',
//       ),
//     );
//   }

//   Widget pumpControl(WaterLevelBloc bloc) {
//     return Positioned(
//         top: 300,
//         left: 200,
//         child: Container(
//           height: 80,
//           width: 80,
//           child: StreamBuilder<int>(
//               stream: bloc.statestream,
//               builder: (context, snapshot) {
//                 if (snapshot.data == 1) {
//                   return pumpbutton(bloc, 'ON', Colors.blue);
//                 } else {
//                   return pumpbutton(bloc, 'OFF', Colors.grey);
//                 }
//               }),
//         ));
//   }



//   Widget undergroundSump() {
//     return Positioned(
//       top: 400,
//       left: 20,
//       child: Image.asset(
//         'assets/sump.png',
//         width: 150.0,
//         height: 150.0,
//         // color: Colors.white,
//       ),
//     );
//   }

//   Widget tanklevel(WaterLevelBloc bloc) {
//     return Positioned(
//         top: 85,
//         left: 180,
//         child: StreamBuilder<int>(
//             stream: bloc.tlevelstream,
//             builder: (context, snapshot) {
//               if (snapshot.hasData && snapshot.data > 1)
//                 return Container(
//                   height: 98,
//                   width: 127,
//                   color: Colors.blue,
//                 );
//               else
//                 return Container(
//                   height: 98,
//                   width: 127,
//                   color: Colors.grey,
//                 );
//             }));
//   }

//   Widget sumplevel(WaterLevelBloc bloc) {
//     return Positioned(
//         top: 440,
//         left: 36,
//         child: StreamBuilder<int>(
//             stream: bloc.slevelstream,
//             builder: (context, snapshot) {
//               if (snapshot.hasData && snapshot.data > 1)
//                 return Container(
//                   decoration: BoxDecoration(
//                       color: Colors.blue,
//                       borderRadius: BorderRadius.circular(10.0)),
//                   height: 82,
//                   width: 120,
//                   child: Column(
//                     children: <Widget>[
//                       // colorlevel(),
//                       // colorlevel(),
//                       // colorlevel(),
//                       // colorlevel()
//                     ],
//                   ),
//                 );
//               else
//                 return Container(
//                   decoration: BoxDecoration(
//                       color: Colors.grey,
//                       borderRadius: BorderRadius.circular(10.0)),
//                   height: 82,
//                   width: 120,
//                 );
//             }));
//   }

//   Container colorlevel() {
//     return Container(
//       height: 20,
//       color: Colors.white10,
//     );
//   }

//   Widget pipeline(WaterLevelBloc bloc) {
//     Color color;
//     if (true) color = Colors.blue;
//     color = Colors.grey;
//     return Positioned(
//       top: 90,
//       left: 45,
//       child: Stack(
//         children: <Widget>[
//           Positioned(
//             child: Container(
//               color: color,
//               width: 8.0,
//               height: 370.0,
//             ),
//           ),
//           Container(
//             width: 135.0,
//             height: 8.0,
//             color: color,
//           )
//         ],
//       ),
//     );
//   }