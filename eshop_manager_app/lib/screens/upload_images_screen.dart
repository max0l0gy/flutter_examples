import 'dart:io';

import 'package:E0ShopManager/services/commodity.dart';
import 'package:E0ShopManager/utils/constants.dart';
import 'package:E0ShopManager/utils/eshop_manager.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UpladImagesScreen extends StatefulWidget {
  final EshopManager eshopManager;
  final List<String> images;

  UpladImagesScreen(this.eshopManager, this.images);

  @override
  _UpladImagesScreenState createState() => _UpladImagesScreenState();
}

class _UpladImagesScreenState extends State<UpladImagesScreen> {
  List<UploadButtonOverImage> upladImages() {
    int idx = 0;
    return widget.images
        .map((image) =>
            UploadButtonOverImage(widget.eshopManager, widget.images, idx++))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload images to commodity'),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: upladImages(), //_typesCardsList,
      ),
    );
  }
}

class UploadButtonOverImage extends StatefulWidget {
  final EshopManager eshopManager;
  final List<String> images;
  final idx;

  UploadButtonOverImage(this.eshopManager, this.images, this.idx);

  @override
  UploadButtonOverImageState createState() => UploadButtonOverImageState();
}

class UploadButtonOverImageState extends State<UploadButtonOverImage> {
  String _imageUrl = '';

  String getItemImageUrlByIdx() {
    return widget.images != null
        ? (widget.images.length > 0 ? widget.images[widget.idx] ?? '' : '')
        : '';
  }

  void setImageToItem(String imageUrl) {
    widget.images[widget.idx] = imageUrl;
  }

  void uploadImageFromDevice() async {
    File file = await FilePicker.getFile();
    if (file != null) {
      String uploaded =
          await CommodityModel(widget.eshopManager).uploadFile(file);
      if (uploaded != null) {
        setImageToItem(uploaded);
        print('uploaded: ${uploaded}');
        setState(() {
          _imageUrl = getItemImageUrlByIdx();
        });
      }
    }
  }

  @override
  void initState() {
    _imageUrl = getItemImageUrlByIdx();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Stack(
        children: [
          FadeInImage.assetNetwork(
            width: EshopNumbers.CREATE_IMAGE_WIDTH,
            height: EshopNumbers.CREATE_IMAGE_HEIGHT,
            fadeInCurve: Curves.bounceIn,
            fit: BoxFit.contain,
            image: _imageUrl,
            placeholder: 'images/placeholder.png',
          ),
          Container(
            width: EshopNumbers.CREATE_IMAGE_WIDTH,
            height: EshopNumbers.CREATE_IMAGE_HEIGHT,
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                uploadImageFromDevice();
              },
              icon: Icon(
                Icons.cloud_upload,
                color: Colors.yellow,
                size: 33,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
