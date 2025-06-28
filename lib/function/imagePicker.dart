import 'dart:io';
import 'dart:developer';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

Future<File?> getImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    File imageFile = File(pickedFile.path);
    await uploadImage(imageFile); // wait for upload to finish
    return imageFile;
  } else {
    return null;
  }
}

Future<void> uploadImage(File? imageFile) async {
  if (imageFile == null) {
    log('No image selected.');
    return;
  }

  try {
    String filePath = const Uuid().v1();
    final ref = FirebaseStorage.instance.ref().child('images/$filePath.jpg');
    final uploadTask = await ref.putFile(imageFile);
    String downloadUrl = await uploadTask.ref.getDownloadURL();
    log('✅ Image uploaded. URL: $downloadUrl');
  } catch (e) {
    log('❌ Error uploading image: $e');
  }
}
