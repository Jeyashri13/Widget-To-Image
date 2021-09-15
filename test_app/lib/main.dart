import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey globalKey = GlobalKey();
  Uint8List? imageMemory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            RepaintBoundary(
              key: globalKey,
              child: Container(
                width: 250.0,
                height: 250.0,
                color: Colors.cyan,
                padding: EdgeInsets.all(20.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () async {
                    await captureImage();
                  },
                  child: Text('Create Image')),
            ),
            if (imageMemory != null)
              Container(
                child: Image.memory(imageMemory!),
              )
          ],
        ),
      ),
    );
  }

  Future<void> captureImage() async {
    RenderRepaintBoundary boundary = globalKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    var bytes =
        await image.toByteData(format: ui.ImageByteFormat.png);
    var pngBytes = await bytes!.buffer.asUint8List();
    print(pngBytes);
    setState(() {
      imageMemory = pngBytes;
    });
  }
}
