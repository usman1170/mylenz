import 'package:flutter/material.dart';
import 'package:lenz/img.dart';
import 'package:share_plus/share_plus.dart';

class TextView extends StatefulWidget {
  const TextView({super.key});

  @override
  State<TextView> createState() => _TextViewState();
}

class _TextViewState extends State<TextView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recognized Text'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () async {
                final sharedText = scannedText;
                await Share.share(scannedText);
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
          child: FutureBuilder<String>(
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                const Center(
                  child: CircularProgressIndicator(),
                );
                break;
              case ConnectionState.done:
                Text(scannedText);
                break;
              default:
            }
            return Text(scannedText);
          }),
        ),
      ]),
    );
  }
}
