import 'package:emissor/env.dart';
import 'package:flutter/material.dart';
import 'package:sms/sms.dart';
import 'dart:convert';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emissor',
      home: const MyHomePage(title: 'Emissor'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final jsonEncoder = const JsonEncoder();

 

  bool isOn = false;
  IconData _btn = Icons.visibility_off;
  Color _mainColor = Colors.white;
  Color _secColor = Colors.black;

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-23.49692, -46.35507),
    zoom: 1,
  );

  GoogleMapController _googleMapController;
  Marker _location;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  void _sendMessage(String message) {
    SmsSender sender = SmsSender();
    String address = receiverNumber;
    sender.sendSms(SmsMessage(address, message));
  }

  Future<void> _smsReceiver() async {
    SmsReceiver receiver = SmsReceiver();

    receiver.onSmsReceived.listen((SmsMessage msg) {
      var messageData = json.decode(msg.body);
      if (msg.address == '+5511$receiverNumber') {
          setState(() {
            _location = Marker(
              markerId: const MarkerId('destination'),
              infoWindow: const InfoWindow(title: 'destination'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              position: LatLng(messageData['latitude'], messageData['longitude']),
            );
            _googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: _location.position,
                  zoom: 60,
                  tilt: 50.0,
                )
              )
            );
        });
      }
    });
  }

  @override
  void initState() {
    _smsReceiver();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        title: const Text('Maps', style: TextStyle(color: Colors.black)),
      ),
      body: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) => _googleMapController = controller,
        markers: {
          if (_location != null) _location,
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _mainColor,
        foregroundColor: _secColor,
        onPressed: _toggleButton,
        child: Icon(
          _btn,
          color: _secColor,
        ),
      ),
    );
  }

  void _toggleButton() {
    if(isOn == false) {
      isOn = true;
      _sendMessage('489751');
      setState(() {
        _btn = Icons.remove_red_eye;
        _mainColor = Colors.black;
        _secColor = Colors.white;
      });
    } else{
      isOn = false;
      _sendMessage('157984');
      setState(() {
        _btn = Icons.visibility_off;
        _mainColor = Colors.white;
        _secColor = Colors.black;
      });
    }
  }
}
