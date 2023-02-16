import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({required this.cameras, Key? key}) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late CameraController _cameraController;

  late Future<void> cameraValue;
  int direction = 0;
  @override
  void initState() {
    super.initState();
    _cameraController =
        CameraController(widget.cameras[direction], ResolutionPreset.high);
    cameraValue = _cameraController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
              future: cameraValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_cameraController);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          GestureDetector(
            onTap: () {
              setState(() {
                direction = direction == 0 ? 1 : 0;
              });
            },
            child: button(Icons.flip_camera_android, Alignment.bottomLeft),
          ),
          GestureDetector(
            onTap: () {
              _cameraController.takePicture().then((XFile file) {
                if (mounted) {
                  if (file != null) {
                    print('Picture saved to the ${file.path}');
                  }
                }
              });
            },
            child: button(Icons.camera_alt_outlined, Alignment.bottomCenter),
          ),
          GestureDetector(
            onTap: () {},
            child: button(Icons.image, Alignment.bottomRight),
          ),
        ],
      ),
    );
  }

  Widget button(
    IconData icon,
    Alignment alignment,
  ) {
    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.only(
          left: 20,
          bottom: 20,
          right: 20,
        ),
        height: 70,
        width: 70,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(255, 148, 158, 158),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 10,
                spreadRadius: 0.3,
              )
            ]),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
            size: 26,
          ),
        ),
      ),
    );
  }
}
