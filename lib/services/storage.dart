import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  Future<firebase_storage.ListResult> listImages() async {
    firebase_storage.ListResult result = await storage.ref('images').listAll();
    for (var reference in result.items) {
      print('Founded file : $reference');
    }
    return result;
  }

  Future<String> downloadUrl(String imagename) async {
    String imageUrl = await storage.ref('images/$imagename').getDownloadURL();
    return imageUrl;
  }
}
