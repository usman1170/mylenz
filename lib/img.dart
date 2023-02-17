import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ImageView extends StatefulWidget {
  ImageView(this.file, {super.key});
  XFile file;
  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    File picture = File(widget.file.path);
    return Scaffold(
      body: Center(
        child: Image.file(picture),
      ),
    );
  }
}
