import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lenz/img.dart';
import 'package:lenz/routes/routes.dart';

late List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lenz',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      // routes: {
      //   imgroute: (context) => ImageView(),
      // },
      debugShowCheckedModeBanner: false,
      home: const CameraScreen(),
    );
  }
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController cameraController;
  @override
  void initState() {
    super.initState();
    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.max,
      enableAudio: false,
    );
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print("Assecss was denied");
            break;
          default:
            print(e.description);
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            child: CameraPreview(cameraController),
          ),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(top: 40, right: 20),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.3)),
                  child: const Center(
                    child: Icon(
                      Icons.flash_on,
                      color: Colors.white,
                      size: 25,
                    ),
                  )),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () async {
                if (!cameraController.value.isInitialized) {
                  return;
                }
                if (cameraController.value.isTakingPicture) {
                  return;
                }
                try {
                  await cameraController.setFlashMode(FlashMode.auto);
                  XFile file = await cameraController.takePicture();
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ImageView(file)),
                  );
                } on CameraException catch (e) {
                  debugPrint("Error while taking picture : $e");
                  return;
                }
              },
              child: Container(
                  width: 70,
                  height: 70,
                  margin: const EdgeInsets.only(
                    bottom: 20,
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.4)),
                  child: const Center(
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 40,
                    ),
                  )),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 30, left: 25),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.4)),
                  child: const Center(
                    child: Icon(
                      Icons.flip_camera_ios,
                      color: Colors.white,
                      size: 30,
                    ),
                  )),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(imgroute);
              },
              child: Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 30, right: 25),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.4)),
                  child: const Center(
                    child: Icon(
                      Icons.image,
                      color: Colors.white,
                      size: 30,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
