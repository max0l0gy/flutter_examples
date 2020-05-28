import 'package:E0ShopManager/screens/attributes_screen.dart';
import 'package:E0ShopManager/screens/type_update_screen.dart';
import 'package:E0ShopManager/services/commodity.dart';
import 'package:E0ShopManager/services/commodity_type.dart';
import 'package:E0ShopManager/utils/constants.dart';
import 'package:E0ShopManager/utils/eshop_manager.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'type_add_screen.dart';

class UpladImagesScreen extends StatefulWidget {
  final EshopManager eshopManager;
  final RequestCommodity item;

  UpladImagesScreen(this.eshopManager, this.item);

  @override
  _UpladImagesScreenState createState() => _UpladImagesScreenState();
}

class _UpladImagesScreenState extends State<UpladImagesScreen> {
  List<UploadButtonOverImage> upladImages() {
    int idx = 0;
    return widget.item.images
        .map((image) =>
            UploadButtonOverImage(widget.eshopManager, widget.item, idx++))
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
      floatingActionButton: new Builder(builder: (BuildContext context) {
        return new FloatingActionButton(
          onPressed: () {
            //_navigateAndDisplaySelection(context);
          },
          tooltip: 'Save images',
          child: const Icon(Icons.save),
        );
      }),
    );
  }
}

class UploadButtonOverImage extends StatelessWidget {
  final EshopManager eshopManager;
  final RequestCommodity item;
  final idx;

  UploadButtonOverImage(this.eshopManager, this.item, this.idx);

  String getItemImage() {
    return item.images != null
        ? (item.images.length > 0 ? item.images[idx] ?? '' : '')
        : '';
  }

  Widget image() {
    String imageUrl = getItemImage();
//    if (imageUrl == '') {
//      return Image.asset(
//        'images/placeholder.png',
//        width: EshopNumbers.CREATE_IMAGE_WIDTH,
//        height: EshopNumbers.CREATE_IMAGE_HEIGHT,
//      );
//    }

    return FadeInImage.assetNetwork(
      width: EshopNumbers.CREATE_IMAGE_WIDTH,
      height: EshopNumbers.CREATE_IMAGE_HEIGHT,
      fadeInCurve: Curves.bounceIn,
      fit: BoxFit.contain,
      image: imageUrl,
      placeholder: 'images/placeholder.png',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Stack(
        children: [
          image(),
          Container(
            width: EshopNumbers.CREATE_IMAGE_WIDTH,
            height: EshopNumbers.CREATE_IMAGE_HEIGHT,
            alignment: Alignment.center,
            child: UploadButton(
              eshopManager,
              item,
              idx,
            ),
          ),
        ],
      ),
    );
  }
}

class UploadButton extends StatelessWidget {
  final EshopManager eshopManager;
  final RequestCommodity item;
  final int idx;

  const UploadButton(this.eshopManager, this.item, this.idx);

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () async {
          File file = await FilePicker.getFile();
          if (file != null) {
            print('File selected: ' + file.path);

            String uploaded =
                await CommodityModel(eshopManager).uploadFile(file);
            print(uploaded);
          }
        },
        icon: Icon(
          Icons.cloud_upload,
          color: Colors.yellow,
          size: 33,
        ),
      );
}
