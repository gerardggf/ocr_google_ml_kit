import 'dart:io';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class HomeGoogleMLKitPage extends StatefulWidget {
  const HomeGoogleMLKitPage({super.key});

  @override
  State<HomeGoogleMLKitPage> createState() => _HomeGoogleMLKitPageState();
}

class _HomeGoogleMLKitPageState extends State<HomeGoogleMLKitPage> {
  File? image;

  String scannedText = "";

  Future<ImageSource?> showImageSource() async {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Galería"),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Cámara"),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 30,
              ),
              if (image != null)
                Image.file(
                  File(image!.path),
                ),
              Text(scannedText),
              if (scannedText != "")
                Icon(searchText("TÉ VERDE") ? Icons.check : Icons.close),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.document_scanner),
        onPressed: () async {
          try {
            final ImageSource? source = await showImageSource();
            pickImage(source!);
          } catch (e) {
            print("No se ha escogido el origen de la imagen a analizar");
          }
        },
      ),
    );
  }

  Future<void> pickImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
      });

      getRecognizedText(image);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Error al escoger a imagen: $e");
      }
    }
  }

  Future<void> getRecognizedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = recognisedText.text;
    setState(() {});
  }

  bool searchText(String text) {
    if (scannedText.contains(text)) {
      return true;
    }
    return false;
  }
}
