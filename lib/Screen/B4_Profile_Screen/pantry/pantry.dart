import 'package:flutter/material.dart';
import 'package:recipe_admin/Screen/Model/add_products..dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Widget/Page_Transformer_Card/page_transformer.dart';
import 'radio_list.dart';

class Pantry extends StatefulWidget {
  const Pantry({Key key}) : super(key: key);

  @override
  _PantryState createState() => _PantryState();
}

class _PantryState extends State<Pantry> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            'Products',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                    color: Color(0xFFFF975D),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    // first tab [you can add an icon using the icon property]
                    Tab(
                      text: 'At Home',
                    ),

                    // second tab [you can add an icon using the icon property]
                    Tab(
                      text: 'Tossed',
                    ),
                  ],
                ),
              ),
              // tab bar view here
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // first tab bar view widget
                    Center(child: GetAtHome()),
                    // second tab bar view widget
                    Center(child: TOSSED()),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

/// =======================This is the home tab==============================

class GetAtHome extends StatefulWidget {
  GetAtHome({Key key}) : super(key: key);

  @override
  _GetAtHomeState createState() => _GetAtHomeState();
}

class _GetAtHomeState extends State<GetAtHome> {
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textPriceController = TextEditingController();
  final _key = GlobalKey<FormState>();
  SharedPreferences prefs;

  //List<String> productName, productPrice;
  var mapData;
  List _items = [];
var order;
  @override
  void initState() {
    //_getData();
    super.initState();
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    _textPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFFFF975D),
          tooltip: 'Add products',
          onPressed: () => _displayTextInputDialog(context),
          child: Icon(Icons.add),
        ),
        body: _items.isEmpty || _items == null ? noItem() : _getItemBuilder);
  }

  Widget get _getItemBuilder => ListView.builder(
        itemCount: _items.length,
        itemBuilder: (BuildContext context, int index) {
          AddProduct product = AddProduct.fromMap(_items[index]);

          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                await _items.removeAt(index);
              } else if (direction == DismissDirection.endToStart) {
                var result = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => RatioTile(context, product)));

                TOSSED(product.name, product.price, result);
                await _items.removeAt(index);
              }
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.delete_forever,
                color: Colors.white,
              ),
            ),
            secondaryBackground: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.grey,
              alignment: Alignment.centerRight,
              child: Text(
                'Tossed',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0,
                    color: Colors.white),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Color(0xFFFF975D), shape: BoxShape.circle),
                    child: Text(
                      index.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headline6,
                  )
                ],
              ),
            ),
          );
        },
      );

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Product'),
            content: Form(
              key: _key,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _textFieldController,
                    autofocus: true,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Empty' : null,
                    decoration: new InputDecoration(
                      labelText: 'Add product',
                      hintText: 'eg. Fresh Basil',
                    ),
                  ),
                  TextFormField(
                    maxLength: 5,
                    keyboardType: TextInputType.number,
                    controller: _textPriceController,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Empty' : null,
                    decoration: new InputDecoration(
                        labelText: 'Price', hintText: 'eg. 200'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Expanded(
                child: TextButton(
                    child: Text(
                      'CANCEL',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
              Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFFF975D), shape: BoxShape.circle),
                  child: new TextButton(
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_key.currentState.validate()) {
                        setState(() {
                          AddProduct product = AddProduct(
                              name: _textFieldController.text.trim(),
                              price: _textPriceController.text.trim());
                          mapData = product.toMap(product);
                          _items.add(mapData);

                          _setlocal(_items);
                          // productName.add(_textFieldController.text);
                          // productPrice.add(_textPriceController.text);
                        });
                        _textPriceController.text = '';
                        _textFieldController.text = '';
                        Navigator.pop(context);
                      }
                    },
                  ))
            ],
          );
        });
  }

  void _setlocal(var _items) async{
    await prefs.setStringList('data', _items);

  }

  // _getData() async {
  // prefs = await  SharedPreferences.getInstance();
  //   await prefs.getStringList(key)}
}

/// If no item cart this class showing

class noItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: 500.0,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding:
                    EdgeInsets.only(top: mediaQueryData.padding.top + 100.0)),
            Image.asset(
              "assets/ilustration/5.png",
              height: 270.0,
            ),
            Text(
              "Product list empty",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 19.5,
                  color: Colors.black26.withOpacity(0.2),
                  fontFamily: "Sofia"),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================ TOSSED==================================

class TOSSED extends StatelessWidget {
  var name;
  var price, result;

  TOSSED([this.name, this.price, this.result]);

  Widget get _getTossed => ListView.builder(
        shrinkWrap: true,
        itemCount: name?.length ?? 6,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0)
            return ListTile(
              title: Text(name ?? 'Pesa'),
              subtitle: Text(
                result ?? 'All of it',
              ),
            );
          else if (index == 1)
            return ListTile(
              title: Text(name ?? 'PineApple'),
              subtitle: Text(
                result ?? 'Half of it',
              ),
            );
          else if (index == 2)
            return ListTile(
              title: Text(name ?? 'Lemons'),
              subtitle: Text(
                result ?? 'Some',
              ),
            );
          else if (index == 3)
            return ListTile(
              title: Text(name ?? 'White fish'),
              subtitle: Text(
                result ?? 'All of it',
              ),
            );
          else if (index == 4)
            return ListTile(
              title: Text(name ?? 'Pesa'),
              subtitle: Text(
                result ?? 'None',
              ),
            );

          return ListTile(
            title: Text(name ?? 'Fish'),
            subtitle: Text(
              result ?? 'Half',
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(child: _getTossed),
        SizedBox(
          height: 10.0,
        ),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Weekly Summary'),
              Text(
                '~ \$17',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
              ),
              Text('Worth of food'),
              ListTile(
                title: Text(name ?? 'Bread'),
                subtitle: Text(
                  result ?? 'Half of food',
                ),
              ),
              ListTile(
                title: Text(name ?? 'Apple'),
                subtitle: Text(
                  result ?? 'Half',
                ),
              ),
              ListTile(
                title: Text(name ?? 'Fish'),
                subtitle: Text(
                  result ?? 'Half',
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
// flutter_icons:
// android: "launcher_icon"
// ios: true
// image_path: "assets/image/ImageApps.png"