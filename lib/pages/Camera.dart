import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gas_tracker/Models/GasStation.dart';
import 'package:gas_tracker/Models/LogEntry.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';

class CameraPage extends StatefulWidget {
  final CameraDescription camera;
  const CameraPage({super.key, required this.camera});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  final _textRecognizer = TextRecognizer();
  late Future<void> _initializeControllerFuture;
  String _toScan = "receipt";
  Map firstFromData = {};

  _CameraPageState();

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
        widget.camera,
        ResolutionPreset.max,
        enableAudio: false
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _textRecognizer.close();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _goToNextForm(String recognizedText) async {
    if (firstFromData.isEmpty) {
      final newFirstFormData = await Navigator.pushNamed(context, 'confirmReceipt', arguments: recognizedText) as Map;
      setState(() {
        // first form was not yet completed, so fill in the data from it
        _toScan = "dashboard";
        firstFromData = newFirstFormData;
      });
    } else {
      // get the data from the second form and go back to home screen
      Navigator.pop(context,
          LogEntry(
              total: firstFromData['total'],
              mileage: (await Navigator.pushNamed(context, 'confirmMileage', arguments: recognizedText) as Map)['mileage'],
              fuelQuantity: firstFromData['quantity'],
              gasStation:  GasStation.values[firstFromData['station']],
              price: firstFromData['price'],
              time: DateTime.now().millisecondsSinceEpoch ~/ 1000
          ));
    }
  }

  Future<void> _onButtonPress()  async {
    try {
      final pictureFile = await _controller.takePicture();

      final croppedFile = await ImageCropper().cropImage(
          sourcePath: pictureFile.path,
          uiSettings: [AndroidUiSettings(lockAspectRatio: false,)]
      );

      final inputImage = InputImage.fromFilePath(croppedFile!.path);
      String recognizedText = (await _textRecognizer.processImage(inputImage)).text;
      log("Recognized: $recognizedText");
      _goToNextForm(recognizedText);
    } catch (e) {
      log(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ooof! error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return  Center(
                child: Container(
                  color: Colors.black,
                  child: CameraPreview(_controller)
                )
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      appBar: AppBar(
        title: Center(child:Text("Scan the $_toScan")),
        titleTextStyle: TextStyle(color: Colors.black),
        automaticallyImplyLeading: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          _onButtonPress();
        },
        child: Icon(
            Icons.document_scanner_outlined,
            color: Colors.white,
        ),
        backgroundColor: Color(0xFF2355D6),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: Center(
                  child: InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.popUntil(context, ModalRoute.withName('home'));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cancel),
                        Text("Cancel"),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(),//to make space for the floating button
              Material(
                color: Colors.transparent,
                child: Center(
                  child: InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        _goToNextForm("");
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.keyboard_double_arrow_right),
                          Text("Skp"),
                          //const Padding(padding: EdgeInsets.only(right: 10))
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}