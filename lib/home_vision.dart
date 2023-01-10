import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import 'package:image_picker/image_picker.dart';

class HomeVisionPage extends StatefulWidget {
  const HomeVisionPage({super.key});

  @override
  State<HomeVisionPage> createState() => _HomeVisionPageState();
}

class _HomeVisionPageState extends State<HomeVisionPage> {
  List<OcrText> listOCRData = [];
  List<String> listData = [];
  bool isInitialized = false;
  File? image;
  String textoBorroso = "";

  Future pickImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Error al esocger a imagen: $e");
      }
    }
  }

  @override
  void initState() {
    FlutterMobileVision.start().then((value) {
      isInitialized = true;
    });
    super.initState();
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
              ...listData.map((item) {
                return Text(item);
              }),
              const SizedBox(
                height: 30,
              ),
              Text(
                textoBorroso,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.document_scanner),
        onPressed: () {
          _startScan();
        },
      ),
    );
  }

  void _startScan() async {
    try {
      listData.clear();
      listOCRData = await FlutterMobileVision.read(
        imagePath: "assets/temp/asdf.png",
        waitTap: true,
        multiple: true,
        fps: 29,
        showText: false,
      );
      checkFields(listOCRData);
      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void checkFields(List<OcrText> listOCRData) {
    for (OcrText item in listOCRData) {
      listData.add(item.value.toUpperCase().trim());
    }
    if (listData.contains("DATOS DE LA EMPRESA")) {
      textoBorroso = "Se ve bien";
    } else {
      textoBorroso = "Se ve borroso";
    }
  }
}
