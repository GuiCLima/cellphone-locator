import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sms/sms.dart';
import 'dart:convert';
import 'package:screen/screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Locator',
      home: MyHomePage(title: 'Locator'),
      debugShowCheckedModeBanner: false,
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

  SmsReceiver receiver = SmsReceiver();
  final jsonEncoder = const JsonEncoder();

  String tuan = '966493808';
  String tuanGranito = '964134681';
  String gui = '914774847';
  String herla = '945828115';
  String fabio = '965748006';
  String gabi = '992403024';
  String oncode = '489751';
  String offcode = '157984'; 

  bool isActive;


  Future<Position> _determinePosition() async {
    bool serviceEnable;
    LocationPermission permission;

    serviceEnable = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnable) {
      return Future.error('Location services are disabled');
    }
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if(permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();

  }

  Future<String> _getPosition() async {
    Position myPosition = await _determinePosition();

    Map<String, double> locationData = {
      'altitude': myPosition.altitude,
      'longitude' : myPosition.longitude,
      'latitude' : myPosition.latitude,
    };
    print(locationData);
    return jsonEncoder.convert(locationData);
  }

  void _sendMessage(String message, String address) {
    SmsSender sender = SmsSender();
    sender.sendSms(SmsMessage(address, message));
  }

  Future<void> _runSmsRoutine() async {
    String position = await _getPosition();
    receiver.onSmsReceived.listen((SmsMessage msg) async{
      if(msg.address == '+5511$tuanGranito' &&  msg.body == oncode) {
        isActive = true;
        do{
          await Future.delayed(const Duration(seconds: 40), () {
            _sendMessage(position, tuanGranito);
          });
        } while(isActive == true);
      } else if(msg.address == '+5511$tuanGranito' &&  msg.body == offcode) {
        isActive = false;
      }
    });
  }

  @override
  void initState() {
    Screen.keepOn(true);
    _runSmsRoutine(); 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
    );
  }
}
