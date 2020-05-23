import 'package:E0ShopManager/services/commodity.dart';
import 'package:E0ShopManager/utils/constants.dart';
import 'package:E0ShopManager/utils/eshop_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemBranchesScreen extends StatefulWidget {
  final EshopManager eshopManager;
  final Commodity commodity;

  ItemBranchesScreen(this.eshopManager, this.commodity);

  @override
  _ItemBranchesState createState() => _ItemBranchesState();
}

class _ItemBranchesState extends State<ItemBranchesScreen> {
  final _formKey = GlobalKey<FormState>();
  CommodityModel _itemModel;

  @override
  Widget build(BuildContext context) {
    Commodity item = widget.commodity;
    return Scaffold(
      appBar: AppBar(
        title: Text('Item id.${widget.commodity.id} branches'),
      ),
      body: Column(
        children: [
          ItemDetailsCard(
            item: item,
            itemModel: _itemModel,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              itemExtent: 106.0,
              children: _branches(),
            ),
          ),
        ],
      ),
      floatingActionButton: AddBranchButton(),
    );
  }

  List<BranchView> _branches() {
    return widget.commodity.branches
        .map((e) => BranchView(
              branch: e,
            ))
        .toList();
  }

  void _updateOrderStateAction() async {
    if (_formKey.currentState.validate()) {
      //todo update order state
      var resp = null;
      Navigator.pop(context, resp);
    }
  }

  @override
  void initState() {
    _itemModel = CommodityModel(widget.eshopManager);
  }
}

class AddBranchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Builder(builder: (BuildContext context) {
        return new FloatingActionButton(
          onPressed: () {
            _navigateToNewBranch(context);
          },
          tooltip: 'Add item branch',
          child: const Icon(Icons.add),
        );
      });

  void _navigateToNewBranch(BuildContext context) {}
}

class ItemDetailsCard extends StatefulWidget {
  final Commodity item;
  final CommodityModel itemModel;

  const ItemDetailsCard({
    this.item,
    this.itemModel,
  });

  @override
  State<StatefulWidget> createState() => _ItemDetailsCardState(
        id: item.id,
        dateOfCreation: item.getDateOfCreation(),
        itemModel: itemModel,
        name: item.name,
        shortDescription: item.shortDescription,
        overview: item.overview,
        imageURIlist: item.images,
      );
}

class _ItemDetailsCardState extends State<StatefulWidget> {
  final _formKey = GlobalKey<FormState>();
  final int id;
  final DateTime dateOfCreation;
  final CommodityModel itemModel;
  String name;
  String shortDescription;
  String overview;
  List<String> imageURIlist;

  _ItemDetailsCardState({
    this.id,
    this.name,
    this.dateOfCreation,
    this.shortDescription,
    this.overview,
    this.imageURIlist,
    this.itemModel,
  });

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
                        Row(
                          children: [
                            EshopHeading('Item id.'),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: Text(id.toString()),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text('created: '),
                            ),
                            Text(DateFormat('dd-MM-yyyy – kk:mm')
                                .format(dateOfCreation)),
                          ],
                        ),
                        Container(
                          width: 200,
                          child: TextFormField(
                            maxLines: null,
                            initialValue: name,
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
                              name = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: FadeInImage.assetNetwork(
                    width: 150.0,
                    height: 200.0,
                    fadeInCurve: Curves.bounceIn,
                    fit: BoxFit.contain,
                    image: imageURIlist[0],
                    placeholder: 'images/placeholder.png',
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: TextFormField(
                maxLines: null,
                initialValue: shortDescription,
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
                  shortDescription = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 10),
              child: TextFormField(
                maxLines: null,
                initialValue: overview,
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
                  overview = value;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BranchView extends StatelessWidget {
  final CommodityBranch branch;
  const BranchView({this.branch});

  List<Widget> _attributes() {
    return branch.attributes
        .map((attribute) => Row(
              children: [
                EshopHeading('${attribute.name}: '),
                Text(attribute.value),
                Text(attribute.measure ?? '')
              ],
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: Column(
                  children: _attributes(),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: _BranchDetails(
                  amount: branch.amount,
                  price: branch.price,
                  currency: branch.currency,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.edit_attributes,
                color: Colors.yellow,
              ),
              tooltip: 'Edit this Type',
            ),
          ],
        ),
      ),
    );
  }
}

class _BranchDetails extends StatelessWidget {
  const _BranchDetails({
    this.amount,
    this.price,
    this.currency,
  });
  final int amount;
  final double price;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          EshopHeading('Amount: ${amount}'),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          EshopHeading('price: ${price} ${currency}'),
        ],
      ),
    );
  }
}
