import 'package:E0ShopManager/components/commodity.dart';
import 'package:E0ShopManager/services/commodity.dart';
import 'package:E0ShopManager/utils/constants.dart';
import 'package:E0ShopManager/utils/eshop_manager.dart';
import 'package:E0ShopManager/validators/commodity_validator.dart';
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
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CommodityModel _itemModel;
  Commodity _item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Item id.${widget.commodity.id} branches'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              ItemDetailsCard(
                eshopManager: widget.eshopManager,
                item: _item,
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
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SaveCommodityInfoButton(
              item: _item,
              itemModel: _itemModel,
              formGlobalKey: _formKey,
            ),
          ],
        ));
  }

  List<BranchView> _branches() {
    return widget.commodity.branches
        .map((e) => BranchView(
              branch: e,
            ))
        .toList();
  }

  @override
  void initState() {
    _item = widget.commodity;
    _itemModel = CommodityModel(widget.eshopManager);
  }
}

class SaveCommodityInfoButton extends StatelessWidget {
  final EshopManager eshopManager;
  final Commodity item;
  final CommodityModel itemModel;
  final GlobalKey<FormState> formGlobalKey;

  const SaveCommodityInfoButton(
      {Key key,
      this.eshopManager,
      this.item,
      this.itemModel,
      this.formGlobalKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Builder(builder: (BuildContext context) {
        return MaterialButton(
          height: 50.0,
          shape: CircleBorder(),
          color: Colors.lime,
          onPressed: () async {
            if (formGlobalKey.currentState.validate()) {
              print('Ready to update item ${item.name}');
              Message mess = await itemModel.updateCommodity(item);
              print('MESSAGE ${mess.message}');
              //_itemUpdate.
              //_navigateToNewBranch(context);
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('Success')));
            }
          },
          child: const Icon(Icons.save),
        );
      });

  void _navigateToNewBranch(BuildContext context) {}
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
  final EshopManager eshopManager;
  final Commodity item;
  final CommodityModel itemModel;

  const ItemDetailsCard({
    this.eshopManager,
    this.item,
    this.itemModel,
  });

  @override
  State<StatefulWidget> createState() => _ItemDetailsCardState(
        item: this.item,
        eshopManager: this.eshopManager,
      );
}

class _ItemDetailsCardState extends State<StatefulWidget> {
  final _formKey = GlobalKey<FormState>();
  final Commodity item;
  final EshopManager eshopManager;

  _ItemDetailsCardState({this.item, this.eshopManager});

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
                              child: Text(item.id.toString()),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text('created: '),
                            ),
                            Text(DateFormat('dd-MM-yyyy – kk:mm').format(
                                DateTime.fromMicrosecondsSinceEpoch(
                                    item.dateOfCreation))),
                          ],
                        ),
                        Container(
                          width: 200,
                          child: TextFormField(
                            maxLines: null,
                            initialValue: item.name,
                            decoration: const InputDecoration(
                              hintText: 'Enter item name',
                            ),
                            validator: CommodityValidation.name,
                            onChanged: (value) {
                              item.name = value.trim();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ItemUploadImage(
                    images: item.images,
                    eshopManager: eshopManager,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: TextFormField(
                maxLines: null,
                initialValue: item.shortDescription,
                decoration: const InputDecoration(
                  hintText: 'Enter short description',
                ),
                validator: CommodityValidation.shortDescription,
                onChanged: (value) {
                  item.shortDescription = value.trim();
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
                validator: CommodityValidation.overview,
                onChanged: (value) {
                  item.overview = value;
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
