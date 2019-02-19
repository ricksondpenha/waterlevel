import 'package:waterlevel/services/tcpsocket.dart';


class DbRepo {
  final tcp = TcpSocket();

  connect() {
    tcp.connect();
  }
}

DbRepo db = DbRepo();