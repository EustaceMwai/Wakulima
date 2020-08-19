import 'package:flutter/material.dart';
import 'package:wakulima/model/product.dart';
import 'package:wakulima/views/product_tile.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    final products = List<Product>();
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text('This is what you have sold so far'),
      ),
      body: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ProductTile(product: products[index]);
          }),
    );
  }
}
