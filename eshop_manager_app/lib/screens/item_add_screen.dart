import 'package:E0ShopManager/screens/upload_images_screen.dart';
import 'package:E0ShopManager/services/attribute.dart';
import 'package:E0ShopManager/services/commodity.dart';
import 'package:E0ShopManager/services/commodity_type.dart';
import 'package:E0ShopManager/utils/constants.dart';
import 'package:E0ShopManager/utils/eshop_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

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
  RequestCommodity _item = RequestCommodity();
  List<CommodityAttribute> _attributes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item of a ${widget.type.name}'),
      ),
      body: ListView(
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
      floatingActionButton: AddItemButton(item: _item),
    );
  }

  void _updateOrderStateAction() async {
    if (_formKey.currentState.validate()) {
      //todo update order state
      var resp = null;
      Navigator.pop(context, resp);
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
    loadAttributes();
  }
}

class AddItemButton extends StatelessWidget {
  final RequestCommodity item;

  const AddItemButton({Key key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) =>
      Builder(builder: (BuildContext context) {
        return new FloatingActionButton(
          onPressed: () {
            print('Selected attributes: ${item.propertyValues}');
            _saveAndNavigateBackToList(context);
          },
          tooltip: 'Add item',
          child: const Icon(Icons.save),
        );
      });

  void _saveAndNavigateBackToList(BuildContext context) {}
}

class ItemDetailsCard extends StatelessWidget {
  final RequestCommodity item;
  final EshopManager eshopManager;

  const ItemDetailsCard(
    this.item,
    this.eshopManager,
  );

  String getItemImage() {
    return item.images != null
        ? (item.images.length > 0 ? item.images[0] ?? '' : '')
        : '';
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
                            initialValue: item.name,
                            decoration: const InputDecoration(
                              hintText: 'Enter item name',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter item name';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              item.name = value;
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
                        image: getItemImage(),
                        placeholder: 'images/placeholder.png',
                      ),
                      Container(
                        width: EshopNumbers.CREATE_IMAGE_WIDTH,
                        height: EshopNumbers.CREATE_IMAGE_HEIGHT,
                        alignment: Alignment.center,
                        child: UploadButton(eshopManager, item),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: TextFormField(
                initialValue: item.shortDescription,
                decoration: const InputDecoration(
                  hintText: 'Enter short description',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some short description';
                  }
                  return null;
                },
                onChanged: (value) {
                  item.shortDescription = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 10),
              child: TextFormField(
                maxLines: null,
                initialValue: item.overview,
                decoration: const InputDecoration(
                  hintText: 'Enter overview',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter overview';
                  }
                  return null;
                },
                onChanged: (value) {
                  item.overview = value;
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
                        maxLines: null,
                        initialValue: item.amount ?? '',
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
                          item.amount = int.parse(value);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: TextFormField(
                        maxLines: null,
                        initialValue: item.price ?? '',
                        decoration: const InputDecoration(
                          hintText: 'Enter price per item',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter price per item';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          item.price = double.parse(value);
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
}

class UploadButton extends StatelessWidget {
  final RequestCommodity item;
  final EshopManager eshopManager;
  const UploadButton(this.eshopManager, this.item);

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return UpladImagesScreen(eshopManager, item);
            }),
          );
        },
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
