import 'package:E0ShopManager/screens/upload_images_screen.dart';
import 'package:E0ShopManager/services/attribute.dart';
import 'package:E0ShopManager/services/commodity.dart';
import 'package:E0ShopManager/services/commodity_type.dart';
import 'package:E0ShopManager/utils/constants.dart';
import 'package:E0ShopManager/utils/eshop_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ItemAddScreen extends StatefulWidget {
  final EshopManager eshopManager;
  final CommodityType type;

  ItemAddScreen(this.eshopManager, this.type);

  @override
  _ItemAddState createState() => _ItemAddState();
}

class _ItemAddState extends State<ItemAddScreen> {
  final _formKey = GlobalKey<FormState>();
  CommodityModel _itemModel;
  AttributeModel _attributeModel;
  RequestCommodity _item = RequestCommodity(currencyCode: 'EUR');
  List<CommodityAttribute> _attributes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item of a ${widget.type.name}'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Column(
              children: [
                ItemDetailsCard(_item, widget.eshopManager),
                ItemAttributesCard(
                  item: _item,
                  attributes: _attributes,
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: Builder(builder: (BuildContext context) {
        return new FloatingActionButton(
          onPressed: () {
            _updateOrderStateAction(context);
          },
          tooltip: 'Add item',
          child: const Icon(Icons.save),
        );
      }),
    );
  }

  void _updateOrderStateAction(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      //valodate attributes of item
      if (_item.propertyValues.length == 0) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Select attributes of item')));
        return;
      }
      //validate images of item
      if (_item.images.length == 0 || _item.images.contains(null)) {
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
                'You should upload ${EshopNumbers.UPLOAD_IMAGES.toString()} images of item')));
        return;
      }
      print('Item json ${_item.toJsonString()}');
      Message mess = await _itemModel.addCommodity(_item);
      print(mess.toJson());
      if (mess != null) {
        //TODO parse message and select action
        if (Message.ERROR == mess.status) {
          if ('Internal storage error' == mess.message)
            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Try to load another images. Image url should be unique per item.')));
          mess.errors.forEach((element) {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text('${element.message}')));
          });
          return;
        }
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Success')));
        Navigator.pop(context, mess);
      }
    }
  }

  Future<void> loadAttributes() async {
    List<CommodityAttribute> attr =
        await _attributeModel.getAttributes(widget.type.id);
    setState(() {
      _attributes = attr;
    });
  }

  @override
  void initState() {
    _itemModel = CommodityModel(widget.eshopManager);
    _attributeModel = AttributeModel(widget.eshopManager);
    _item.typeId = widget.type.id;
    loadAttributes();
  }
}

class ItemDetailsCard extends StatefulWidget {
  final RequestCommodity item;
  final EshopManager eshopManager;

  const ItemDetailsCard(
    this.item,
    this.eshopManager,
  );

  @override
  State<ItemDetailsCard> createState() => ItemDetailCardState();
}

class ItemDetailCardState extends State<ItemDetailsCard> {
  String imgUrl = '';

  String getItemFirstImage() {
    return widget.item.images != null
        ? (widget.item.images.length > 0 ? widget.item.images[0] ?? '' : '')
        : '';
  }

  void updateImage() {
    setState(() {
      imgUrl = getItemFirstImage();
    });
  }

  @override
  void initState() {
    updateImage();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 200,
                          child: TextFormField(
                            maxLines: null,
                            initialValue: widget.item.name,
                            decoration: const InputDecoration(
                              hintText: 'Enter item name',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter item name';
                              }
                              if (value.trim().length < 8 ||
                                  value.trim().length > 256) {
                                return 'Name length 8-256';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              widget.item.name = value.trim();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      FadeInImage.assetNetwork(
                        width: EshopNumbers.CREATE_IMAGE_WIDTH,
                        height: EshopNumbers.CREATE_IMAGE_HEIGHT,
                        fadeInCurve: Curves.bounceIn,
                        fit: BoxFit.contain,
                        image: imgUrl,
                        placeholder: 'images/placeholder.png',
                      ),
                      Container(
                        width: EshopNumbers.CREATE_IMAGE_WIDTH,
                        height: EshopNumbers.CREATE_IMAGE_HEIGHT,
                        alignment: Alignment.center,
                        child: UploadImagesButton(
                            onPressed: _navigateToUploadAndUpdateState),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: TextFormField(
                initialValue: widget.item.shortDescription,
                decoration: const InputDecoration(
                  hintText: 'Enter short description',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some short description';
                  }
                  if (value.trim().length < 16 || value.trim().length > 256) {
                    return 'Short description length 16-256';
                  }
                  return null;
                },
                onChanged: (value) {
                  widget.item.shortDescription = value.trim();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 10),
              child: TextFormField(
                maxLines: null,
                initialValue: widget.item.overview,
                decoration: const InputDecoration(
                  hintText: 'Enter overview',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter overview';
                  }
                  if (value.trim().length < 64 || value.trim().length > 2048) {
                    return 'overview length 64-2048';
                  }
                  return null;
                },
                onChanged: (value) {
                  widget.item.overview = value.trim();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextFormField(
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        initialValue: widget.item.amount.toString(),
                        decoration: const InputDecoration(
                          hintText: 'Enter amount of items',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter amount';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          widget.item.amount = int.tryParse(value);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: TextFormField(
                        initialValue: widget.item.price.toString(),
                        decoration: const InputDecoration(
                          hintText: 'Enter price per item',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter price per item';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Incorrect price';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          widget.item.price = double.tryParse(value);
                        },
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _navigateToUploadAndUpdateState() async {
    var formResp = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return UpladImagesScreen(widget.eshopManager, widget.item);
      }),
    );
    if (formResp == null) {
      print('Update image after upload images');
      updateImage();
    }
  }
}

class UploadImagesButton extends StatelessWidget {
  final VoidCallback onPressed;

  const UploadImagesButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: onPressed,
        icon: Icon(
          Icons.cloud_upload,
          color: Colors.yellow,
          size: 33,
        ),
      );
}

class ItemAttributesCard extends StatefulWidget {
  final List<CommodityAttribute> attributes;
  final RequestCommodity item;

  ItemAttributesCard({Key key, this.attributes, this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ItemAttributesCardState(item);
}

class ItemAttributesCardState extends State<ItemAttributesCard> {
  final RequestCommodity item;

  ItemAttributesCardState(this.item);

  List<CheckboxListTile> getAttributesView() {
    List<CheckboxListTile> viewList = [];
    widget.attributes.forEach((attr) {
      viewList.addAll(
        attr.values
            .map(
              (v) => CheckboxListTile(
                checkColor: Colors.yellow,
                title: Row(
                  children: [
                    Expanded(flex: 1, child: Text(attr.name)),
                    Expanded(flex: 2, child: Text(v.value.toString())),
                    Expanded(flex: 2, child: Text(attr.measure ?? '')),
                  ],
                ),
                value: item.propertyValues.contains(v.id),
                onChanged: (bool value) {
                  setState(() {
                    if (value) {
                      item.propertyValues.add(v.id);
                      timeDilation = EshopNumbers.DELAITION_MAX;
                    } else {
                      item.propertyValues.remove(v.id);
                      timeDilation = EshopNumbers.DELAITION_MIN;
                    }
                    print("attributeValues>>");
                    print(item.propertyValues);
                  });
                },
              ),
            )
            .toList(),
      );
    });
    return viewList;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: getAttributesView(),
        ),
      ),
    );
  }
}
