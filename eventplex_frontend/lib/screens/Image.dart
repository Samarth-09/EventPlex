import 'dart:io';
// import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  File? img;
  // File? img;
  void takephoto() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    img = File(image!.path);
    setState(() {});
// Capture a photo.
    // final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    // img = File(photo!.path);
    // setState(() {});
// // Pick a video.
//     final XFile? galleryVideo =
//         await picker.pickVideo(source: ImageSource.gallery);
// // Capture a video.
//     final XFile? cameraVideo =
//         await picker.pickVideo(source: ImageSource.camera);

// Pick multiple images.
    // final List<XFile> images = await picker.pickMultiImage(); 
    // List<String> l=[];
    // int j=1;
    // for (var element in images) {
    //   //read each image file as bytes (uint8 encoded)
    //   var x = await element.readAsBytes();

    //   //converts bytes to String i.e creates a string from charater codes
    //   String s = String.fromCharCodes(x);
    //   //This String to be stored in the database
    //   // print(s);
    //   l.add(s);
    //   img.add(File(element.path));
    //   //covert String(made from codes) to uint8
    //   // Uint8List y = Uint8List.fromList(s.codeUnits);
    //   // print(1);
    //   // //create a temporary file at a temporary directory and then write those image's byte to the file
    //   // var tempDir = await getTemporaryDirectory();
    //   // File f = await File('${tempDir.path}/image${j++}.png').create();
    //   // print(2);
    //   // f.writeAsBytesSync(y);
    //   // print(3);
    //   // img.add(f);
    // }
    // print(l);
    // await Dio().post("http://localhost:3001/event/saveEvent", data: {"images": l});
    // // images.forEach((element) async {

    // // });
    // setState(() {});

    // img =  List.generate(images.length, (index)  {

    // XFile? i = await picker.pickImage(source: ImageSource.gallery);
    // img = File(i!.path);
    // var x = await img!.readAsBytes();

    // img = await File('${tempDir.path}/image.png').create();
    // img!.writeAsBytesSync(x);

    // print(s);
    // Uint8List y = Uint8List.fromList(s.codeUnits);
    //   return File(images[index].path);});

    // var y = Uint8List.fromList(x);
    // img = File.fromRawPath(x);
    // print(f.path);
    // print(x);
// // Pick singe image or video.
//     final XFile? media = await picker.pickMedia();
// // Pick multiple images and videos.
//     final List<XFile> medias = await picker.pickMultipleMedia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        (img != null)
        ? Image.file(img!)
        // ...(List.generate((img.isEmpty) ? 0 : img.length,
        //     (index) => Image.file(img[index], width: 100, height: 100))),
        : Container(),
        FloatingActionButton(onPressed: () => takephoto())
      ],
    ));
  }
}
