import 'package:flutter/material.dart';
import 'package:recipe_admin/Screen/Model/add_products..dart';

class RatioTile extends StatefulWidget {
  dynamic val;
  AddProduct product;

  RatioTile(this.val, this.product);

  @override
  _RatioTileState createState() => _RatioTileState();
}

class _RatioTileState extends State<RatioTile> {
  var _radio = 0;
  var title;

  Widget _radioListTile(dynamic val, String _title) {
    return RadioListTile(
        value: val,
        groupValue: _radio,
        title: Text(_title),
        activeColor: Color(0xFFFF975D),
        onChanged: (val) {
          setState(() {
            _radio = val;
            title = _title;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(
                  Icons.highlight_remove,
                  color: Color(0xFFFF975D),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            SizedBox(height: 150.0,),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    'How much ${widget.product.name} did you toss?',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  _radioListTile(0, 'All of it'),
                  _radioListTile(1, 'Most of it'),
                  _radioListTile(2, 'Half'),
                  _radioListTile(3, 'Same'),
                  _radioListTile(4, 'None'),
                  Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFFF975D), shape: BoxShape.circle),
                      child: new TextButton(
                        child: const Text(
                          'Toss',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pop(context,title);
                        },
                      ))
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
