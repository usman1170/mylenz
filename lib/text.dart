import 'package:flutter/material.dart';
import 'package:lenz/img.dart';

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
