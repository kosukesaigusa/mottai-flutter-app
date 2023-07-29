import 'dart:io';

import 'package:flutter/material.dart';
import '../image_pick.dart';

class ImagePickSample extends StatefulWidget {
  const ImagePickSample({super.key});

  @override
  State<ImagePickSample> createState() => _ImagePickSampleState();
}

class _ImagePickSampleState extends State<ImagePickSample> {
  File? singleImage;
  List<File> multiImages = <File>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '端末内の画像を選択する機能のサンプル',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 60),
          const Center(child: Text('1枚のイメージを選択')),
          if (singleImage == null)
            _noImageWidget(singlePick)
          else
            _imageWidget(singleImage!, singlePick),
          const SizedBox(height: 60),
          const Center(child: Text('複数のイメージを選択')),
          if (multiImages.isEmpty)
            _noImageWidget(multiPick)
          else
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: multiImages.length,
                itemBuilder: (_, index) {
                  return _imageWidget(multiImages[index], multiPick);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _noImageWidget(VoidCallback action) {
    return InkWell(
      onTap: action,
      child: Center(
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black38),
          ),
          child: const Icon(Icons.image),
        ),
      ),
    );
  }

  Widget _imageWidget(File file, VoidCallback action) {
    return InkWell(
      onTap: action,
      child: SizedBox(
        height: 200,
        width: 200,
        child: Image.file(file),
      ),
    );
  }

  Future<void> singlePick() async {
    try {
      final image = await fetchSingleImage(PickType.gallery);
      if (image != null) {
        setState(() {
          singleImage = image;
        });
      }
    } on Exception catch (e) {
      print(e);
      //SnackBarなどの表示
    }
  }

  Future<void> multiPick() async {
    try {
      final images = await fetchMultipleImage();
      if (images.isNotEmpty) {
        setState(() {
          multiImages = images;
        });
      }
    } on Exception catch (e) {
      //SnackBarなどの表示
    }
  }
}
