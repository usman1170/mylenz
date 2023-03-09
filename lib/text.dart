import 'package:flutter/material.dart';
import 'package:lenz/img.dart';
import 'package:share_plus/share_plus.dart';

// ignore: must_be_immutable
class TextView extends StatefulWidget {
  TextView(this.text, {super.key});
  String text;

  @override
  State<TextView> createState() => _TextViewState();
}

class _TextViewState extends State<TextView> {
  @override
  Widget build(BuildContext context) {
    String finalText = widget.text;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recognized Text'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () async {
                final sharedText = scannedText;
                await Share.share(sharedText);
              },
              icon: const Icon(Icons.share),
            ),
          )
        ],
      ),
      body: ListView(children: [
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(10),
            child: Text(finalText))
      ]),
    );
  }
}
