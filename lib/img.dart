import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lenz/text.dart';

bool textscanning = false;
XFile? imagefile;
String scannedText = '';
XFile? img;

// ignore: must_be_immutable
class ImageView extends StatefulWidget {
  ImageView(this.file, {super.key});
  XFile file;
  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  void proccessimage() async {
    try {
      final pickedImage = img;
      if (pickedImage != null) {
        textscanning = true;
        setState(() {
          getText(pickedImage);
        });
      }
    } catch (e) {
      textscanning = false;
      imagefile = null;
      scannedText = 'Error occured while scanning';
      setState(() {});
    }
  }

  void getText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = '';
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
      }
    }
    textscanning = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    File picture = File(widget.file.path);
    img = XFile(widget.file.path);
    return Scaffold(
      body: ListView(children: [
        Container(
          margin: const EdgeInsets.only(top: 0),
          child: Center(
            child: Image.file(picture),
          ),
        ),
      ]),
      bottomNavigationBar: BottomAppBar(
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => SimpleDialog(
                title: const Text('Proccess image to'),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            proccessimage();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TextView()),
                            ).then((value) {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(
                              top: 12,
                              left: 8,
                              right: 8,
                              bottom: 10,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 10,
                                bottom: 2,
                              ),
                              child: Text(
                                "English",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(
                              top: 12,
                              left: 8,
                              right: 8,
                              bottom: 10,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 2),
                              child: Text(
                                "Urdu",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 95, 242, 227),
                    Color.fromARGB(255, 2, 128, 115),
                  ]),
            ),
            height: 70,
            child: const Center(
              child: Text(
                'Proccess image',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
