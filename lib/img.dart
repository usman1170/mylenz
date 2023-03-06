import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lenz/text.dart';
import 'package:lenz/toasts/toast.dart';
import 'package:http/http.dart' as http;

bool textscanning = false;
String scannedText = '';
String? _base64;

// ignore: must_be_immutable
class ImageView extends StatefulWidget {
  ImageView(this.file, {super.key});
  XFile file;
  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // APi Funcrion
  Future<void> sendImage(File image) async {
    // String base64 = base6(image);
    const url = 'https://us-central1-risetech.cloudfunctions.net/vision-api';
    final api = Uri.parse(url);
    final responce = await http.post(api,
        headers: {'conrent-type': 'application/json'},
        body: jsonEncode(
          {'image': base64},
        ));
    // ignore: avoid_print
    print('Responce status = ${responce.statusCode}');
    // ignore: avoid_print
    print('Responce body = ${responce.body}');
  }

  // Firebase function
  void uploadimage(XFile image) async {
    try {
      firebase_storage.UploadTask uploadTask;
      firebase_storage.Reference reference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('images')
          .child('/${image.name}');
      uploadTask = reference.putFile(File(image.path));
      await uploadTask.whenComplete(() => null);
      final imageUrl = await reference.getDownloadURL();
      firestore
          .collection('images')
          .doc('r3EDWp2hNMjqkvcnv7Lk')
          .set({
            'url': imageUrl,
          })
          .then((value) => print('Images path added to firestore'))
          .catchError(
              (error) => print('failed to upload path due to : $error'));
      // ignore: avoid_print
      print('Uploaded image url is : $imageUrl');
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  // Google ML kit functions
  void getUrduText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = '';
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = "$scannedText${line.text}\n";
      }
    }
    textscanning = false;
    setState(() {});
  }

  void getEnglishText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = '';
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = "$scannedText${line.text}\n";
      }
    }
    textscanning = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    File picture = File(widget.file.path);

    return Scaffold(
      backgroundColor: Colors.transparent,
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
                            final img = XFile(widget.file.path);
                            getEnglishText(img);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TextView(scannedText)),
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
                            final img = XFile(widget.file.path);
                            getEnglishText(img);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TextView(scannedText)),
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
                        GestureDetector(
                          onTap: () {
                            final img = XFile(widget.file.path);
                            uploadimage(img);
                            setState(() {
                              Navigator.of(context).pop();
                            });
                            image_saved_toast;
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
                                "Save image",
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
            child: const Padding(
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
              ),
              child: Center(
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
      ),
    );
  }
}
