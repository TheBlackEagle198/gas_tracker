import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gas_tracker/pages/Camera.dart';
import 'package:gas_tracker/pages/ConfirmMileage.dart';
import 'package:gas_tracker/pages/ConfirmReceipt.dart';
import 'package:gas_tracker/pages/Home.dart';
import 'package:gas_tracker/pages/Statistics.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<CameraDescription> cameras = await availableCameras();
  CameraDescription camera = cameras.where((description) => description.lensDirection == CameraLensDirection.back).toList().first;
  runApp(MaterialApp(
    initialRoute: 'home',
    theme: ThemeData(
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: Color(0xFF2355D6)
      ),
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelStyle: TextStyle(
            color: Color(0xFF2355D6)
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF2355D6)
          )
        ),
        focusColor: Color(0xFF2355D6)
      )
    ),
    routes: {
      'home': (context) => const HomePage(),
      'confirmReceipt': (context) => ConfirmReceiptPage(),
      'confirmMileage': (context) => ConfirmMileagePage(),
      'cameraPage': (context) => CameraPage(camera: camera),
    },
  ));
}