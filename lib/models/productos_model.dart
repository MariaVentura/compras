import 'package:flutter/material.dart';

class ProductosModel {
  final String name;
  final String image;
  final Color color;
  final double price;
  int quantity;

  ProductosModel({this.name, this.image, this.color, this.price, this.quantity = 1});
}
